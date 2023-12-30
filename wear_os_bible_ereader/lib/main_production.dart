import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:wear_os_bible_ereader/app/app.dart';
import 'package:wear_os_bible_ereader/bootstrap.dart';

Future<void> main() async {
  final bookshelfRepository = FlutterWearOsConnectivityBookshelfRepository();
  await bookshelfRepository.initialize();
  await bootstrap(() => App(bookshelfRepository: bookshelfRepository));
}
