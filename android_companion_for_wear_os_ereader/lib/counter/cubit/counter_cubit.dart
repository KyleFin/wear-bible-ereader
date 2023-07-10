import 'package:bloc/bloc.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(this.connectivity) : super(0);

  final FlutterWearOsConnectivity connectivity;

  Future<void> increment() async {
    // final isSupported = await connectivity.isSupported();
    // print(isSupported);
    final devices = await connectivity.getConnectedDevices();
    print(devices);
    emit(state + 1);
  }

  void decrement() => emit(state - 1);
}
