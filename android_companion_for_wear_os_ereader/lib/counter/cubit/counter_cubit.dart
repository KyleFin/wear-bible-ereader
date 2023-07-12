import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(this.bookshelfRepository) : super(0) {
    // connectivity.dataChanged().listen((event) {
    //   print(event);
    // });
  }

  // final FlutterWearOsConnectivity connectivity;
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

  Future<void> increment() async {
    // final isSupported = await connectivity.isSupported();
    // print(isSupported);
    //final device = await connectivity.getLocalDevice();
    //final devices = await connectivity.getConnectedDevices();
    // final dataItems = await connectivity.getAllDataItems();
    //final sync =

    // await connectivity.syncData(
    //   path: '/bookshelf-titles-to-paths',
    //   data: {
    //     'Grimm Fairy Tales': '/grimm-path',
    //     'Alice in Wonderland': '/alice-path',
    //   },
    //   isUrgent: true,
    // );
    // await connectivity.syncData(
    //   path: '/path_count_$state',
    //   data: {
    //     'count': state,
    //   },
    //   isUrgent: true,
    // );
    // final afterDataItems = await connectivity.getAllDataItems();
    // await connectivity.deleteDataItems(
    //     uri: Uri(
    //         scheme: "wear",
    //         host: '70708221', // specific device id
    //         path: "/path_count_2"));
    // final items = await connectivity.getAllDataItems();
    //print(afterDataItems);

    // await bookshelfRepository.addBook(
    //   title: 'Frankenstein',
    //   path: '/frank',
    //   file: File(''),
    // );
    emit(state + 1);
  }

  Future<void> decrement() async {
    emit(state - 1);
  }
}
