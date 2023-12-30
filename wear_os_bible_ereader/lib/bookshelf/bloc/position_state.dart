part of 'position_bloc.dart';

@JsonSerializable()
class PositionState extends Equatable {
  const PositionState(
    this.bookTitle,
    this.scriptureBookIndex,
    this.chapterIndex,
    this.epubCfi, {
    required this.latestBookFilename,
    required this.loadingDocument,
  });

  const PositionState.initial()
      : this(
          null,
          null,
          null,
          null,
          latestBookFilename: bibleFilename,
          loadingDocument: false,
        );

  /// Connect the generated [_$PositionStateFromJson] function to the `fromJson`
  /// factory.
  factory PositionState.fromJson(Map<String, dynamic> json) =>
      _$PositionStateFromJson(json);

  /// Connect the generated [_$PositionStateToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PositionStateToJson(this);

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

  /// True when EpubController is loading a new document from file.
  final bool loadingDocument;

  /// True when a chapter from Table of Contents has been selected.
  bool get chapterIsSelected => chapterIndex != null;

  /// True when a book from bookshelf has been selected.
  bool get bookIsSelected => bookTitle != null;

  bool get latestBookIsScripture =>
      latestBookFilename == bibleFilename || latestBookFilename == bofmFilename;

  bool get bookTitleIsScripture => titleToFilename.keys.contains(bookTitle);

  @override
  List<Object?> get props => [
        latestBookFilename,
        bookTitle,
        scriptureBookIndex,
        chapterIndex,
        epubCfi,
        loadingDocument,
      ];
}
