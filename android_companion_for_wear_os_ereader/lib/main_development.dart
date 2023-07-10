import 'package:android_companion_for_wear_os_ereader/app/app.dart';
import 'package:android_companion_for_wear_os_ereader/bootstrap.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

void main() {
  bootstrap((c) => App(flutterWearOsConnectivity: c));
}
