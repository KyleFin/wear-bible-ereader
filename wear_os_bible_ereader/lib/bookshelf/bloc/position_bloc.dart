import 'package:bloc/bloc.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:equatable/equatable.dart';

part 'position_state.dart';

class PositionCubit extends Cubit<PositionState> {
  PositionCubit(this.bookshelfRepository)
      : super(const PositionState.initial());

  final BookshelfRepository bookshelfRepository;

  Future<void> openBook(String title) async {
    assert(
      titleToFilename.containsKey(title) ||
          bookshelfRepository.titlesAndFilepaths.containsKey(title),
      'Invalid book title',
    );
    emit(
      PositionState(
        title,
        null,
        null,
        null,
        latestBookFilename: state.latestBookFilename,
        loadingDocument: state.loadingDocument,
      ),
    );
  }

  Future<void> closeBook() async => emit(
        PositionState(
          null,
          null,
          null,
          null,
          latestBookFilename: state.latestBookFilename,
          loadingDocument: state.loadingDocument,
        ),
      );

  /// Return to previous menu. Returned bool determines whether page should pop.
  Future<bool> popMenu() async {
    // if (state.epubCfi != null) {
    //   await setEpubCfi(null);
    //   return false;
    // }
    if (state.chapterIndex != null) {
      emit(
        PositionState(
          state.bookTitle,
          state.scriptureBookIndex,
          null,
          null,
          latestBookFilename: state.latestBookFilename,
          loadingDocument: state.loadingDocument,
        ),
      );
      return false;
    }
    if (state.scriptureBookIndex != null) {
      emit(
        PositionState(
          state.bookTitle,
          null,
          null,
          null,
          latestBookFilename: state.latestBookFilename,
          loadingDocument: state.loadingDocument,
        ),
      );
      return false;
    }
    await closeBook();
    return true;
  }

  Future<void> setLoadingDocument(bool value) async {
    emit(
      PositionState(
        state.bookTitle,
        state.scriptureBookIndex,
        state.chapterIndex,
        state.epubCfi,
        latestBookFilename: state.latestBookFilename,
        loadingDocument: value,
      ),
    );
  }

  Future<void> setLatestBookFilename(String filename) async {
    emit(
      PositionState(
        state.bookTitle,
        state.scriptureBookIndex,
        state.chapterIndex,
        state.epubCfi,
        latestBookFilename: filename,
        loadingDocument: state.loadingDocument,
      ),
    );
  }

  void setScriptureBookIndex(int index) => emit(
        PositionState(
          state.bookTitle,
          index,
          null,
          null,
          latestBookFilename: state.latestBookFilename,
          loadingDocument: state.loadingDocument,
        ),
      );

  /// [index] represents the EpubViewChapter's startIndex for use in scrollTo.
  void selectChapter(int index) => emit(
        PositionState(
          state.bookTitle,
          state.scriptureBookIndex,
          index,
          null,
          latestBookFilename: state.latestBookFilename,
          loadingDocument: state.loadingDocument,
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
/// https://www.mobileread.com/forums/showthread.php?t=31709
const bibleFilename = 'kjvCh.epub';

/// https://www.globalgreyebooks.com/book-of-mormon-ebook.html
const bofmFilename = 'bofmGlobalGrey.epub';

const titleToFilename = {
  oldTestament: bibleFilename,
  newTestament: bibleFilename,
  bookOfMormon: bofmFilename,
};
