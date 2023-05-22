import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wear_os_bible_ereader/counter/counter.dart';
import 'package:wear_os_bible_ereader/epub/epub.dart';
import 'package:wear_os_bible_ereader/l10n/l10n.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: BookshelfPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PositionCubit>();
    return //state.bookTitle == null ?
        Scaffold(
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.libraryAppBarTitle),
          const SizedBox(height: 10),
          for (final k in titleToFilename.keys)
            ElevatedButton(
              onPressed: () => cubit.openBook(k),
              child: Text(k),
            ),
          // const CounterText(),
          // const SizedBox(height: 10),
        ],
        // ),
        // : state.bookIsLoading
        //     ? const Text('Loading')
        //     :
        //     // EpubViewTableOfContents()
        //     ListView(
        //         // mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           for (final c in cubit.chapters())
        //             ElevatedButton(
        //               onPressed: () => cubit.openBook(c),
        //               child: Text(c),
        //             ),
        //           const SizedBox(height: 10),
        //           Text(l10n.libraryAppBarTitle),
        //           const CounterText(),
        //           const SizedBox(height: 10),
        //         ],
        //       );
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((PositionCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
