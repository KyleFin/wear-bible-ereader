import 'package:bloc/bloc.dart';
import 'package:epub_view/epub_view.dart';
import 'package:equatable/equatable.dart';

class PositionCubitState extends Equatable {
  const PositionCubitState(
    this.bookTitle,
    this.chapterIndex,
    this.subchapterIndex,
    this.epubCfi, {
    required this.bookIsLoading,
  });

  const PositionCubitState.initial()
      : this(
          null,
          null,
          null,
          null,
          bookIsLoading: false,
        );

  final bool bookIsLoading;
  final String? bookTitle;
  final int? chapterIndex;
  final int? subchapterIndex;
  final String? epubCfi;

  @override
  List<Object?> get props =>
      [bookIsLoading, bookTitle, chapterIndex, subchapterIndex, epubCfi];
}

class PositionCubit extends Cubit<PositionCubitState> {
  PositionCubit() : super(const PositionCubitState.initial());

// TODO: Move controller to widget tree (to listen for isBookLoaded etc)
// FlowBuilder to manage stack of pages
// Cubit handles storing "page" indices and logic for which chapters to display? Loading states? (probably let controller ChangeNotifiers do loading)
// Controller handles creating list and text widgets. BlocListener to respond to cubit states
// https://github.com/felangel/bloc/issues/2293#issuecomment-814359073
  EpubController? _epubController;

  Future<void> openBook(String title) async {
    assert(titleToFilename.containsKey(title), 'Invalid book title');
    final filename = titleToFilename[title];
    final loadRequired = filename != titleToFilename[state.bookTitle];
    emit(
      PositionCubitState(
        title,
        null,
        null,
        null,
        bookIsLoading: loadRequired,
      ),
    );
    if (loadRequired) {
      _epubController?.dispose();
      _epubController = //await Future.value(
          EpubController(document: EpubDocument.openAsset('assets/$filename'));
      //);
      _epubController?.isBookLoaded.addListener(
        () => emit(
          PositionCubitState(title, null, null, null, bookIsLoading: false),
        ),
      );
    }
  }

  List<String> chapters() {
    return _epubController!.isBookLoaded.value
        ? _epubController!
            .tableOfContents()
            .where((c) => c.type == 'chapter')
            .map((c) => c.title ?? 'No chapter title found')
            .toList()
        : ['did', 'not', 'load'];
  }

  void selectChapter(int index) => emit(
        PositionCubitState(
          state.bookTitle,
          index,
          null,
          null,
          bookIsLoading: false,
        ),
      );

  @override
  Future<void> close() async {
    _epubController?.dispose();
    await super.close();
  }
}

const oldTestament = 'Old Testament';
const newTestament = 'New Testament';
const bookOfMormon = 'Book of Mormon';

const titleToFilename = {
  oldTestament: 'kjvCh.epub',
  newTestament: 'kjvCh.epub',
  bookOfMormon: 'bofm.epub',
};
