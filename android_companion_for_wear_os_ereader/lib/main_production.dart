import 'package:android_companion_for_wear_os_ereader/app/app.dart';
import 'package:android_companion_for_wear_os_ereader/bootstrap.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';

void main() {
  bootstrap(
    () => App(
      bookshelfRepository: FlutterWearOsConnectivityBookshelfRepository(),
    ),
  );
}
