import 'package:android_companion_for_wear_os_ereader/transfer/transfer.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterCubit', () {
    test('initial state is 0', () {
      expect(TransferCubit().state, equals(0));
    });

    blocTest<TransferCubit, int>(
      'emits [1] when increment is called',
      build: TransferCubit.new,
      act: (cubit) => cubit.increment(),
      expect: () => [equals(1)],
    );

    blocTest<TransferCubit, int>(
      'emits [-1] when decrement is called',
      build: TransferCubit.new,
      act: (cubit) => cubit.decrement(),
      expect: () => [equals(-1)],
    );
  });
}
