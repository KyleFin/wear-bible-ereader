import 'dart:io';

import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Implementation of [BookshelfRepository] which has no external dependencies.
///
/// For use in local development and testing.
class MockBookshelfRepository implements BookshelfRepository {
  /// Stream informs listeners when bookshelf changes.
  final _titlesAndFilepaths = BehaviorSubject<Map<String, String>>.seeded({});

  final _files = <String, File>{};

  @override
  Map<String, String> get titlesAndFilepaths => _titlesAndFilepaths.value;

  @override
  Stream<Map<String, String>> get titlesAndFilepathsStream =>
      _titlesAndFilepaths.stream.distinct();

  @override
  Future<void> addBook({
    required String title,
    required String path,
    required File file,
  }) async {
    if (titlesAndFilepaths.containsKey(title)) {
      // TODO: Return status message to display in UI?
      print('$title already in bookshelf');
      return;
    }

    _titlesAndFilepaths.add({...titlesAndFilepaths, title: path});
    _files[path] = file;
  }

  @override
  Future<void> deleteBook(String title) async {
    if (titlesAndFilepaths.containsKey(title)) {
      final path = titlesAndFilepaths[title];
      _files.remove(path);

      final newTitles = {...titlesAndFilepaths}..remove(title);
      _titlesAndFilepaths.add(newTitles);
    }
  }

  @override
  Future<void> onChange() {
    // Not needed for mock.
    // Used for companion / wear to respond to updates from the other.
    throw UnimplementedError();
  }

  @override
  Future<File?> getBookFile(String title) async => _files[title];

  @override
  void dispose() {
    _titlesAndFilepaths.close();
  }
}
