import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PositionCubitState extends Equatable {
  const PositionCubitState(
    this.bookTitle,
    this.scriptureBookIndex,
    this.chapterIndex,
    this.epubCfi, {
    required this.latestBook,
  });

  const PositionCubitState.initial()
      : this(
          null,
          null,
          null,
          null,
          latestBook: bibleFilename,
        );

  /// Latest epub file which was loaded in Epub controller.
  ///
  /// If user returns to root menu then goes back to the same book, we need not
  /// reload it.
  final String latestBook;

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

  @override
  List<Object?> get props =>
      [latestBook, bookTitle, scriptureBookIndex, chapterIndex, epubCfi];
}

class PositionCubit extends Cubit<PositionCubitState> {
  PositionCubit() : super(const PositionCubitState.initial());

  Future<void> openBook(String title) async {
    assert(titleToFilename.containsKey(title), 'Invalid book title');
    emit(
        PositionCubitState(
        title,
          null,
          null,
          null,
          latestBook: state.latestBook,
        ),
      );
  }

  Future<void> closeBook() async => emit(
      PositionCubitState(
        null,
        null,
        null,
          null,
        latestBook: state.latestBook,
      ),
    );

  Future<void> setLatestBook(String filename) async {
    emit(
      PositionCubitState(
        state.bookTitle,
        state.scriptureBookIndex,
        state.chapterIndex,
        state.epubCfi,
        latestBook: filename,
      ),
    );
  }

  void setScriptureBookIndex(int index) => emit(
        PositionCubitState(
          state.bookTitle,
          index,
          null,
          null,
          latestBook: state.latestBook,
        ),
      );

  /// [index] represents the EpubViewChapter's startIndex for use in scrollTo.
  void selectChapter(int index) => emit(
        PositionCubitState(
          state.bookTitle,
          state.scriptureBookIndex,
          index,
          null,
          latestBook: state.latestBook,
        ),
      );

  @override
  Future<void> close() async {
    await super.close();
  }
}

const oldTestament = 'Old Testament';
const newTestament = 'New Testament';
const bookOfMormon = 'Book of Mormon';

// These versions support chapters in table of contents and scrollTo.
/// http://www.mobileread.mobi/forums/showthread.php?t=31709
const bibleFilename = 'kjvCh.epub';

/// https://www.globalgreyebooks.com/book-of-mormon-ebook.html
const bofmFilename = 'bofmGlobalGrey.epub';

const titleToFilename = {
  oldTestament: bibleFilename,
  newTestament: bibleFilename,
  bookOfMormon: bofmFilename,
};
