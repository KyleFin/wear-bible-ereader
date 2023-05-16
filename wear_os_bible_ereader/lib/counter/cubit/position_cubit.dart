import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PositionCubitState extends Equatable {
  const PositionCubitState(
    this.bookTitle,
    this.chapterIndex,
    this.subchapterIndex,
    this.epubCfi, {
    required this.bookIsLoading,
    required this.latestBook,
  });

  const PositionCubitState.initial()
      : this(
          null,
          null,
          null,
          null,
          bookIsLoading: false,
          latestBook: bibleFilename,
        );

  final bool bookIsLoading; // TODO remove? (Handled by controller and EpubView)
  final String latestBook;
  final String? bookTitle;
  final int? chapterIndex;
  final int? subchapterIndex; // TODO combine into List<int> chapterIndices?
  final String? epubCfi;

  @override
  List<Object?> get props => [
        bookIsLoading,
        latestBook,
        bookTitle,
        chapterIndex,
        subchapterIndex,
        epubCfi
      ];
}

class PositionCubit extends Cubit<PositionCubitState> {
  PositionCubit() : super(const PositionCubitState.initial());

  Future<void> closeBook() async => emit(
        PositionCubitState(
          null,
          null,
          null,
          null,
          bookIsLoading: false,
          latestBook: state.latestBook,
        ),
      );

  Future<void> openBook(String title) async {
    assert(titleToFilename.containsKey(title), 'Invalid book title');
    final filename = titleToFilename[title]!;
    final loadRequired = filename != titleToFilename[state.bookTitle];
    emit(
      PositionCubitState(
        title,
        null,
        null,
        null,
        bookIsLoading: loadRequired,
        latestBook: state.latestBook,
      ),
    );
    // if (loadRequired) {
    //   _epubController?.dispose();
    //   _epubController = //await Future.value(
    //       EpubController(document: EpubDocument.openAsset('assets/$filename'));
    //   //);
    //   _epubController?.isBookLoaded.addListener(
    //     () => emit(
    //       PositionCubitState(title, null, null, null, bookIsLoading: false),
    //     ),
    //   );
    // }
  }

  Future<void> setLatestBook(String filename) async {
    emit(
      PositionCubitState(
        state.bookTitle,
        state.chapterIndex,
        state.subchapterIndex,
        state.epubCfi,
        bookIsLoading: state.bookIsLoading,
        latestBook: filename,
      ),
    );
  }

  // List<String> chapters() {
  //   return _epubController!.isBookLoaded.value
  //       ? _epubController!
  //           .tableOfContents()
  //           .where((c) => c.type == 'chapter')
  //           .map((c) => c.title ?? 'No chapter title found')
  //           .toList()
  //       : ['did', 'not', 'load'];
  // }

  void selectChapter(int index) => emit(
        PositionCubitState(
          state.bookTitle,
          index,
          null,
          null,
          bookIsLoading: false,
          latestBook: state.latestBook,
        ),
      );

  // ignore: avoid_positional_boolean_parameters
  void setBookIsLoading(bool value) => emit(
        PositionCubitState(
          state.bookTitle,
          state.chapterIndex,
          state.subchapterIndex,
          state.epubCfi,
          bookIsLoading: value,
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

const bibleFilename = 'kjvCh.epub';
const bofmFilename = 'bofm.epub';

const titleToFilename = {
  oldTestament: bibleFilename,
  newTestament: bibleFilename,
  bookOfMormon: bofmFilename,
};
