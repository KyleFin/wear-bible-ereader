import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

// See https://pub.dev/packages/epub_view and
// https://github.com/ScerIO/packages.flutter/blob/main/packages/epub_view/example/lib/main.dart

class EpubWidget extends StatefulWidget {
  const EpubWidget({required this.filename, super.key});

  final String filename;

  @override
  State<EpubWidget> createState() => _EpubWidgetState();
}

class _EpubWidgetState extends State<EpubWidget> {
  late EpubController _epubController;
  @override
  void initState() {
    super.initState();
    _epubController = EpubController(
      // book.epub is from epub_view sample project
      // kjvCh.epub has chapters from http://www.mobileread.mobi/forums/showthread.php?t=31709
      // kjv.epub is EPUB (no images) from https://www.gutenberg.org/ebooks/10
      // bofm.epub is EPUB (no images) from https://www.gutenberg.org/ebooks/17
      document: EpubDocument.openAsset('assets/${widget.filename}'),
      // Set start point
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return EpubView(
  //     // builders: EpubViewBuilders<DefaultBuilderOptions>(
  //     //   options: const DefaultBuilderOptions(),
  //     //   chapterDividerBuilder: (_) => const Divider(),
  //     // ),
  //     controller: _epubController,
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: EpubViewActualChapter(
            controller: _epubController,
            builder: (chapterValue) => Text(
              chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
              textAlign: TextAlign.start,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save_alt),
              color: Colors.white,
              onPressed: () => _showCurrentEpubCfi(context),
            ),
          ],
        ),
        drawer: Drawer(
          child: EpubViewTableOfContents(
            controller: _epubController,
            itemBuilder: (context, index, chapter, itemCount) =>
                chapter.type == 'chapter' //'subchapter'
                    ? ListTile(
                        title: Text(chapter.title!.trim()),
                        onTap: () =>
                            _epubController.jumpTo(index: chapter.startIndex),
                      )
                    : const SizedBox.shrink(),
          ),
        ),
        body: EpubView(
          builders: EpubViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            chapterDividerBuilder: (_) => const Divider(),
          ),
          controller: _epubController,
        ),
      );

  void _showCurrentEpubCfi(BuildContext context) {
    final cfi = _epubController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cfi),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubController.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }
}
