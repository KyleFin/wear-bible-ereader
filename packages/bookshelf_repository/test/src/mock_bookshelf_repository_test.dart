import 'dart:io';

import 'package:bookshelf_repository/src/mock_bookshelf_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockBookshelfRepository', () {
    test('has empty initial value', () {
      expect(MockBookshelfRepository().titlesAndFilepaths, equals({}));
    });

    test('returns stream with initial value', () async {
      expect(
        await MockBookshelfRepository().titlesAndFilepathsStream.first,
        equals({}),
      );
    });

    group('addBook', () {
      test('replaces initial value', () {
        final repository = MockBookshelfRepository()
          ..addBook(title: 't', path: 'p', file: File('f'));
        expect(repository.titlesAndFilepaths, equals({'t': 'p'}));
      });

      test('adds value to stream', () async {
        final repository = MockBookshelfRepository();
        final second = repository.titlesAndFilepathsStream.elementAt(1);
        await repository.addBook(title: 't', path: 'p', file: File('f'));
        expect(await second, equals({'t': 'p'}));
      });
    });

    group('deleteBook', () {
      test('updates value', () {
        final repository = MockBookshelfRepository()
          ..addBook(title: 't', path: 'p', file: File('f'));
        expect(repository.titlesAndFilepaths, equals({'t': 'p'}));

        repository.deleteBook('t');
        expect(repository.titlesAndFilepaths, equals({}));
      });

      test('updates stream', () async {
        final repository = MockBookshelfRepository();
        final fourth = repository.titlesAndFilepathsStream.elementAt(3);
        await repository.addBook(title: '1', path: 'p', file: File('f'));
        await repository.addBook(title: '2', path: 'p', file: File('f'));

        await repository.deleteBook('1');
        expect(await fourth, equals({'2': 'p'}));
      });
    });

    test('onChange throws unimplemented', () {
      expect(
        () => MockBookshelfRepository().onChange(),
        throwsUnimplementedError,
      );
    });

    group('getBookFile', () {
      test('returns null for title not in bookshelf', () async {
        final repository = MockBookshelfRepository();
        expect(await repository.getBookFile('p'), isNull);
      });

      test('returns path for title in bookshelf', () async {
        final repository = MockBookshelfRepository();
        await repository.addBook(title: 't', path: 'p', file: File('f'));
        expect((await repository.getBookFile('p'))!.path, equals('f'));
      });

      test('returns null for title deleted from bookshelf', () async {
        final repository = MockBookshelfRepository();
        await repository.addBook(title: 't', path: 'p', file: File('f'));
        expect((await repository.getBookFile('p'))!.path, equals('f'));

        await repository.deleteBook('t');
        expect(await repository.getBookFile('p'), isNull);
      });
    });

    test('initialize does not throw', () async {
      final repository = MockBookshelfRepository();
      expect(repository.initialize(), completes);
    });

    test('dispose closes stream', () async {
      final repository = MockBookshelfRepository()..dispose();
      expect(
        () => repository.addBook(title: 't', path: 'p', file: File('f')),
        throwsStateError,
      );
    });
  });
}
