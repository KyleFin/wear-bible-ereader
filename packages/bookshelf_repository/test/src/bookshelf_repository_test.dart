// ignore_for_file: prefer_const_constructors

import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookshelfRepository', () {
    test('can be instantiated', () {
      expect(BookshelfRepository(), isNotNull);
    });
  });
}
