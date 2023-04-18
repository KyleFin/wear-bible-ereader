import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

// See https://pub.dev/packages/epub_view and
// https://github.com/ScerIO/packages.flutter/blob/main/packages/epub_view/example/lib/main.dart

class EpubWidget extends StatefulWidget {
  const EpubWidget({super.key});

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
      // kjv.epub is EPUB (no images) from https://www.gutenberg.org/ebooks/10
      document: EpubDocument.openAsset('assets/kjv.epub'),
      // Set start point
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EpubView(
      // builders: EpubViewBuilders<DefaultBuilderOptions>(
      //   options: const DefaultBuilderOptions(),
      //   chapterDividerBuilder: (_) => const Divider(),
      // ),
      controller: _epubController,
    );
  }
}
