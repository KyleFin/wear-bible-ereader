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
          final currBookFilename = titleToFilename[current.bookTitle];
          final openNewBookRequired = currBookFilename != null &&
              // TODO Verify with tests (did with breakpoints).
              // Only change controller if opening a different book.
              currBookFilename != current.latestBook;
          final scrollToNewLocationRequired =
              previous.chapterIndex != current.chapterIndex;
          return openNewBookRequired || scrollToNewLocationRequired;
        },
        listener: (context, state) {
          if (state.chapterIndex != null) {
            _epubReaderController.scrollTo(index: state.chapterIndex!);
          }

          final bookFilename = titleToFilename[state.bookTitle]!;
          if (bookFilename != state.latestBook) {
            context.read<PositionCubit>().setLatestBook(bookFilename);
            _epubReaderController.dispose();
            _epubReaderController = EpubController(
              document: EpubDocument.openAsset(
                'assets/$bookFilename',
              ),
            );
          }
        },
        child: FlowBuilder(
          state: context.watch<PositionCubit>().state,
          onGeneratePages: onGeneratePages,
        ),
      ),
      // home: const CounterPage(),
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
        await context.read<PositionCubit>().closeBook();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Details')),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child:
                // TODO: Figure out why this code (copied from EpubViewTableOfContents)
                // doesn't get past loading spinner but changing to EpubView then back
                // while running app gets it to work.
                // MAY BE EASIER to get (sub)chapters directly from controller.document
                // instead of tableOfContentsListenable. (Looks like that may be
                // nicer for names and numSubchapters but may not have indices needed
                // for scrollTo)
                BlocBuilder<PositionCubit, PositionCubitState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    //   ValueListenableBuilder(
                    // valueListenable: epubController.tableOfContentsListenable,
                    // builder: (_, data, child) {
                    //   Widget content;

                    //   if (data.isNotEmpty) {
                    //     content = ListView.builder(
                    //       // padding: padding,
                    //       key: Key('$runtimeType.content'),
                    //       itemBuilder: (context, index) {
                    //         final chapter = data[index];
                    //         // TODO: check cubit selection to decide what to display
                    //         return chapter.type == 'chapter'
                    //             ? ListTile(
                    //                 title: Text(chapter.title!.trim()),
                    //                 onTap: () => epubController.scrollTo(
                    //                     index: chapter.startIndex),
                    //               )
                    //             : const SizedBox.shrink();
                    //       },
                    //       itemCount: data.length,
                    //     );
                    //   } else {
                    //     content = KeyedSubtree(
                    //       key: Key('$runtimeType.loader'),
                    //       child: const Center(child: CircularProgressIndicator()),
                    //     );
                    //   }

                    //   return AnimatedSwitcher(
                    //     duration: const Duration(milliseconds: 250),
                    //     transitionBuilder:
                    //         (Widget child, Animation<double> animation) =>
                    //             FadeTransition(opacity: animation, child: child),
                    //     child: content,
                    //   );
                    // },
                    // ),
                    EpubView(controller: epubController),
                    if (state.chapterIndex == null) ...[
                      Container(color: Colors.black),
                      EpubViewTableOfContents(
                          controller: epubController,
                          itemBuilder: (context, index, chapter, itemCount) =>
                              //     //     chapter.type == 'chapter'
                              //     //         ?
                              ListTile(
                                title: Text(chapter.title!.trim()),
                                onTap: () => context
                                    .read<PositionCubit>()
                                    .selectChapter(chapter.startIndex),
                              )
                          //         : const SizedBox.shrink(),
                          ),
                    ],
                  ],
                );
              },
            ),
          )),
    );
  }
}
