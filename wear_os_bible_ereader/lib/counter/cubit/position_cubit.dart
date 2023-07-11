import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

class PositionCubitState extends Equatable {
  const PositionCubitState(
    this.bookTitle,
    this.scriptureBookIndex,
    this.chapterIndex,
    this.epubCfi,
    this.titlesFromCompanion, {
    required this.latestBookFilename,
  });

  const PositionCubitState.initial()
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

class PositionCubit extends Cubit<PositionCubitState> {
  PositionCubit(this.flutterWearOsConnectivity)
      : super(const PositionCubitState.initial());

  final FlutterWearOsConnectivity flutterWearOsConnectivity;

  Future<void> openBook(String title) async {
    // final device = await flutterWearOsConnectivity.getLocalDevice();
    // final devices = await flutterWearOsConnectivity.getConnectedDevices();
    // final items = await flutterWearOsConnectivity.getAllDataItems();
    // items.forEach((i) {
    //   print(i.data);
    // });
    assert(titleToFilename.containsKey(title), 'Invalid book title');
    emit(
      PositionCubitState(
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
        PositionCubitState(
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
        PositionCubitState(
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
        PositionCubitState(
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
      PositionCubitState(
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
        PositionCubitState(
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
        PositionCubitState(
          state.bookTitle,
          state.scriptureBookIndex,
          index,
          null,
          state.titlesFromCompanion,
          latestBookFilename: state.latestBookFilename,
        ),
      );

  Iterable<String> get bookshelfTitles =>
      [...titleToFilename.keys, ...state.titlesFromCompanion];

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
