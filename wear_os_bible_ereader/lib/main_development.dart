import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:wear_os_bible_ereader/app/app.dart';
import 'package:wear_os_bible_ereader/bootstrap.dart';

void main() {
  bootstrap(() => App(bookshelfRepository: MockBookshelfRepository()));
}
