import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wear_os_bible_ereader/bookshelf/bookshelf.dart';

void main() {
  group('PositionCubit', () {
    test('initial state is 0', () {
      expect(PositionCubit().state, equals(0));
    });

    blocTest<PositionCubit, int>(
      'emits [1] when increment is called',
      build: PositionCubit.new,
      act: (cubit) => cubit.increment(),
      expect: () => [equals(1)],
    );

    blocTest<PositionCubit, int>(
      'emits [-1] when decrement is called',
      build: PositionCubit.new,
      act: (cubit) => cubit.decrement(),
      expect: () => [equals(-1)],
    );
  });
}
