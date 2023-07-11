import 'dart:io';

/// {@template bookshelf_repository}
/// Manages synchronizing books between companion and Wear OS apps.
/// {@endtemplate}
abstract class BookshelfRepository {
  /// {@macro bookshelf_repository}
  const BookshelfRepository();

  /// Returns map of titles and their filepaths currently in the bookshelf.
  Map<String, String> get titlesAndFilepaths;

  /// Returns stream of titles and their filepaths currently in the bookshelf.
  /// Adds latest value as first item for new listeners.
  Stream<Map<String, String>> get titlesAndFilepathsStream;

  /// Add book to bookshelf.
  Future<void> addBook({
    required String title,
    required String path,
    required File file,
  });

  /// Remove book from bookshelf. Deletes files from watch storage.
  Future<void> deleteBook(String title);

  /// Callback that is executed when book added or deleted is detected.
  ///
  /// For example, when watch app detects that companion has added a new book.
  Future<void> onChange();

  /// Returns [File] using filepath for book with [title].
  Future<File> getBookFile(String title);

  /// Clean up when repository is disposed.
  void dispose();
}
