part of 'position_bloc.dart';

class PositionState extends Equatable {
  const PositionState(
    this.bookTitle,
    this.scriptureBookIndex,
    this.chapterIndex,
    this.epubCfi,
    this.titlesFromCompanion, {
    required this.latestBookFilename,
  });

  const PositionState.initial()
      : this(
          null,
          null,
          null,
          null,
          const [],
          latestBookFilename: bibleFilename,
        );

  /// Latest epub file which was loaded in Epub controller.
  ///
  /// If user returns to root menu then goes back to the same book, we need not
  /// reload it.
  final String latestBookFilename;

  final String? bookTitle;

  /// Index within table of contents of selected scripture book.
  ///
  /// Used to decide how many chapters should be displayed in sub-chapter menu.
  final int? scriptureBookIndex;

  /// Represents the EpubViewChapter's startIndex for use in scrollTo.
  final int? chapterIndex;

  /// Stores current position as text is scrolled. Used for cold boot.
  final String?
      epubCfi; // TODO make Map<String, String?> to store latest cfi for each epub file?

  bool get latestBookIsScripture =>
      latestBookFilename == bibleFilename || latestBookFilename == bofmFilename;

  final List<String> titlesFromCompanion;

  @override
  List<Object?> get props => [
        latestBookFilename,
        bookTitle,
        scriptureBookIndex,
        chapterIndex,
        epubCfi,
        titlesFromCompanion,
      ];
}
