import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';

class TransferCubit extends Cubit<int> {
  TransferCubit(this.bookshelfRepository) : super(0);

  final BookshelfRepository bookshelfRepository;

  Future<void> addBook(File f) async {
    final filename = f.path.split('/').last.split('.').first;
    await bookshelfRepository.addBook(
      title: filename,
      path: '/$filename',
      file: f,
    );
  }

  Future<void> deleteBook(String title) async {
    await bookshelfRepository.deleteBook(title);
  }
}
