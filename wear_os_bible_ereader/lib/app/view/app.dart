import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear_os_bible_ereader/counter/counter.dart';
import 'package:wear_os_bible_ereader/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Page> onGeneratePages(PositionCubitState state, List<Page> pages) {
    final selectedBook = state.bookTitle;
    return [
      BookshelfPage.page(),
      if (selectedBook != null)
        BookDetailsPage.page(epubController: _epubReaderController),
    ];
  }

  late EpubController _epubReaderController;

  @override
  void initState() {
    _epubReaderController = EpubController(
      document: EpubDocument.openAsset('assets/kjvCh.epub'),
      // epubCfi:
      //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
      // epubCfi:
      //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
    );
    super.initState();
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(primary: Colors.white),
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocListener<PositionCubit, PositionCubitState>(
        listenWhen: (previous, current) {
          final title = current.bookTitle;
          final currBookFilename = titleToAssetFilename.containsKey(title)
              ? titleToAssetFilename[title]
              : title;
          final openNewBookRequired = currBookFilename != null &&
              // TODO Verify with tests (did with breakpoints).
              // Only change controller if opening a different book.
              currBookFilename != current.latestBookFilename;
          final scrollToNewLocationRequired =
              previous.chapterIndex != current.chapterIndex;
          return openNewBookRequired || scrollToNewLocationRequired;
        },
        listener: (context, state) {
          if (state.chapterIndex != null) {
            _epubReaderController.scrollTo(index: state.chapterIndex!);
          }

          final title = state.bookTitle;
          final bookIsAsset = titleToAssetFilename.containsKey(title);
          final bookFilename =
              bookIsAsset ? titleToAssetFilename[state.bookTitle]! : title!;
          if (bookFilename != state.latestBookFilename) {
            context.read<PositionCubit>().setLatestBookFilename(bookFilename);
            _epubReaderController.dispose();
            _epubReaderController = EpubController(
              document: bookIsAsset
                  ? EpubDocument.openAsset(
                      'assets/$bookFilename',
                    )
                  : EpubDocument.openFile(File(bookFilename)),
            );
          }
        },
        child: FlowBuilder(
          state: context.watch<PositionCubit>().state,
          onGeneratePages: onGeneratePages,
        ),
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({required this.epubController, super.key});

  static Page page({required EpubController epubController}) {
    return MaterialPage<void>(
      child: BookDetailsPage(epubController: epubController),
    );
  }

  final EpubController epubController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return context.read<PositionCubit>().popMenu();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<PositionCubit, PositionCubitState>(
            builder: (context, state) {
              return Stack(
                children: [
                  // Always build EpubView (and sometimes hide it behind menu)
                  // since it seems to handle all the controller loading and
                  // listenable notification logic. I originally tried having
                  // table of contents in a separate page (instead of a Stack)
                  // but it would never get notified that listenable values
                  // changed or that the document finished loading. I'm not
                  // sure if this is the best approach, but it seems to work
                  // well having an EpubView always in the widget tree (even
                  // if it's not visible).
                  EpubView(controller: epubController),
                  if (state.chapterIndex == null) ...[
                    Container(color: Theme.of(context).colorScheme.background),
                    TableOfContents(epubController: epubController),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// MAY BE EASIER to get (sub)chapters directly from controller.document
// instead of tableOfContentsListenable. (Looks like that may be
// nicer for names and numSubchapters but may not have indices needed
// for scrollTo)
class TableOfContents extends StatelessWidget {
  const TableOfContents({required this.epubController, super.key});

  final EpubController epubController;

  @override
  Widget build(BuildContext context) {
    final state = context.read<PositionCubit>().state;
    if (state.latestBookIsScripture) {
      return ScriptureSelectionMenu(epubController: epubController);
    }
    // Non-scripture books display all chapters and sub-chapters in one menu.
    return EpubViewTableOfContents(
      controller: epubController,
      itemBuilder: (context, index, chapter, itemCount) => ListTile(
        title: Text(chapter.title!.trim()),
        onTap: () =>
            context.read<PositionCubit>().selectChapter(chapter.startIndex),
      ),
    );
  }
}

/// Scriptures handle selecting book then chapter (subchapter) in separate menu.
class ScriptureSelectionMenu extends StatelessWidget {
  const ScriptureSelectionMenu({required this.epubController, super.key});

  static const int newTestamentStartingIndexInTableOfContents = 969;

  final EpubController epubController;

  bool _shouldIncludeBook(String? bookTitle, int index) {
    switch (bookTitle) {
      case oldTestament:
        return index < newTestamentStartingIndexInTableOfContents;
      case newTestament:
        return index >= newTestamentStartingIndexInTableOfContents;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PositionCubit>();
    // This ValueListenableBuilder is based on EpubViewTableOfContents.
    return ValueListenableBuilder(
      valueListenable: epubController.tableOfContentsListenable,
      builder: (_, data, child) {
        Widget content;

        if (data.isNotEmpty) {
          // I would have made these separate widgets, but EpubViewChapter
          // (data's type) is private within epub_view.
          content = cubit.state.scriptureBookIndex == null
              // Book selection menu
              ? ListView.builder(
                  // padding: padding,
                  key: Key('$runtimeType.content'),
                  itemBuilder: (context, index) {
                    final chapter = data[index];
                    return chapter.type == 'chapter' &&
                            _shouldIncludeBook(cubit.state.bookTitle, index)
                        ? ListTile(
                            title: Text(chapter.title!.trim()),
                            // Skip chapter selection if less than 2 subchapters
                            onTap: data[index + 1].type == 'chapter' ||
                                    data[index + 2].type == 'chapter'
                                ? () => cubit.selectChapter(chapter.startIndex)
                                : () => cubit.setScriptureBookIndex(index),
                          )
                        : const SizedBox.shrink();
                  },
                  itemCount: data.length,
                )
              // Chapter selection menu
              : GridView.count(
                  crossAxisCount: 3,
                  children: () {
                    final chaptersInBook = <Widget>[];
                    var i = cubit.state.scriptureBookIndex! + 1;
                    var foundNextBook = false;

                    final originalIndex = i;
                    final startIndexForBook =
                        data[originalIndex - 1].startIndex;

                    while (i < data.length && !foundNextBook) {
                      final chapter = data[i];
                      final currIndex = i;
                      if (chapter.type == 'subchapter') {
                        chaptersInBook.add(
                          ListTile(
                            title: Text(chapter.title!.trim().split(' ').last),
                            onTap: () => cubit.selectChapter(
                              // Fix Bible chapter 1 startIndex == chapter 2 by
                              // having chapter 1 instead go to start of book.
                              cubit.state.latestBookFilename == bibleFilename &&
                                      currIndex == originalIndex
                                  ? startIndexForBook
                                  : chapter.startIndex,
                            ),
                          ),
                        );
                      } else {
                        foundNextBook = true;
                      }
                      i++;
                    }
                    return chaptersInBook;
                  }(),
                );
        } else {
          content = KeyedSubtree(
            key: Key('$runtimeType.loader'),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(opacity: animation, child: child),
          child: content,
        );
      },
    );
  }
}
