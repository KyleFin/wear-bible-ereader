import 'package:bloc/bloc.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(this.connectivity) : super(0);

  final FlutterWearOsConnectivity connectivity;

  Future<void> increment() async {
    // final isSupported = await connectivity.isSupported();
    // print(isSupported);
    //final device = await connectivity.getLocalDevice();
    //final devices = await connectivity.getConnectedDevices();
    //final dataItems = await connectivity.getAllDataItems();
    //final sync =
    await connectivity
        .syncData(path: '/bookshelf-titles-to-paths', data: {
          'Grimm Fairy Tales': '/grimm-path',
          'Alice in Wonderland': '/alice-path',
          });
    // final afterDataItems = await connectivity.getAllDataItems();
    // await connectivity.deleteDataItems(
    //     uri: Uri(
    //         scheme: "wear",
    //         host: '70708221', // specific device id
    //         path: "/sample-path"));
    // final items = await connectivity.getAllDataItems();
    //print(afterDataItems);
    emit(state + 1);
  }

  void decrement() => emit(state - 1);
}
