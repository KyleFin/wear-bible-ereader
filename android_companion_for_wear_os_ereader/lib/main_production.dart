import 'package:android_companion_for_wear_os_ereader/app/app.dart';
import 'package:android_companion_for_wear_os_ereader/bootstrap.dart';

void main() {
  bootstrap((c) => App(bookshelfRepository: c));
}
