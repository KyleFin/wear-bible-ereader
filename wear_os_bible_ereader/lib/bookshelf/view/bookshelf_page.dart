import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear_os_bible_ereader/app/view/rotary_scrollable.dart';
import 'package:wear_os_bible_ereader/bookshelf/bookshelf.dart';
import 'package:wear_os_bible_ereader/l10n/l10n.dart';

const verticalSpacer = SizedBox(height: 30);

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: BookshelfPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PositionCubit>();
    final bookshelfRepository = context.read<BookshelfRepository>();
    return //state.bookTitle == null ?
        Scaffold(
      body: StreamBuilder<Iterable<String>>(
        initialData: bookshelfRepository.titlesAndFilepaths.keys,
        stream: bookshelfRepository.titlesAndFilepathsStream.map((t) => t.keys),
        builder: (context, snapshot) {
          // TODO: Only respond to rotary scrolls if bookshelf is displayed.
          return RotaryScrollable(
            childBuilder: (scrollController) => ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              controller: scrollController,
              children: [
                verticalSpacer,
                // Text(l10n.libraryAppBarTitle),
                const SizedBox(height: 10),
                for (final t in [...titleToFilename.keys, ...snapshot.data!])
                  ElevatedButton(
                    onPressed: () => cubit.openBook(t),
                    child: Text(t),
                  ),
                verticalSpacer,
              ],
            ),
          );
        },
      ),
      // const CounterText(),
      // const SizedBox(height: 10),
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
