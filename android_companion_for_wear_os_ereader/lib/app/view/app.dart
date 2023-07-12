import 'package:android_companion_for_wear_os_ereader/counter/counter.dart';
import 'package:android_companion_for_wear_os_ereader/l10n/l10n.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({required this.bookshelfRepository, super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
    bookshelfRepository.initialize();
  }

  final BookshelfRepository bookshelfRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: bookshelfRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
