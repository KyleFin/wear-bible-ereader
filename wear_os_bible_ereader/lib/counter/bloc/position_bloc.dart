import 'package:bloc/bloc.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:equatable/equatable.dart';

part 'position_state.dart';

class PositionCubit extends Cubit<PositionState> {
  PositionCubit(this.bookshelfRepository)
      : super(const PositionState.initial());

  final BookshelfRepository bookshelfRepository;

  Future<void> openBook(String title) async {
    // final device = await flutterWearOsConnectivity.getLocalDevice();
    // final devices = await flutterWearOsConnectivity.getConnectedDevices();
    // final items = await flutterWearOsConnectivity.getAllDataItems();
    // items.forEach((i) {
    //   print(i.data);
    // });
    bookshelfRepository.titlesAndFilepaths;
    assert(titleToFilename.containsKey(title), 'Invalid book title');
    emit(
      PositionState(
        title,
        null,
        null,
        null,
        state.titlesFromCompanion,
        latestBookFilename: state.latestBookFilename,
      ),
    );
  }

  Future<void> closeBook() async => emit(
        PositionState(
          null,
          null,
          null,
          null,
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
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
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
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
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
        ),
      );
      return false;
    }
    await closeBook();
    return true;
  }

  Future<void> setLatestBookFilename(String filename) async {
    emit(
      PositionState(
        state.bookTitle,
        state.scriptureBookIndex,
        state.chapterIndex,
        state.epubCfi,
        state.titlesFromCompanion,
        latestBookFilename: filename,
      ),
    );
  }

  void setScriptureBookIndex(int index) => emit(
        PositionState(
          state.bookTitle,
          index,
          null,
          null,
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
        ),
      );

  /// [index] represents the EpubViewChapter's startIndex for use in scrollTo.
  void selectChapter(int index) => emit(
        PositionState(
          state.bookTitle,
          state.scriptureBookIndex,
          index,
          null,
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
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
