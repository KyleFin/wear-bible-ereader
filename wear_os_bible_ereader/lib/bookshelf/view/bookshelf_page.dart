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
    return Scaffold(
      body: StreamBuilder<Iterable<String>>(
        initialData: bookshelfRepository.titlesAndFilepaths.keys,
        stream: bookshelfRepository.titlesAndFilepathsStream.map((t) => t.keys),
        builder: (context, snapshot) {
          return context.select((PositionCubit c) => c.state.bookTitle != null)
              ? const SizedBox()
              // Only respond to rotary scrolls if bookshelf is displayed.
              : RotaryScrollable(
                  childBuilder: (scrollController) => ListView(
                    controller: scrollController,
                    children: [
                      verticalSpacer,
                      // Text(l10n.libraryAppBarTitle),
                      const SizedBox(height: 10),
                      for (final t in [
                        ...titleToFilename.keys,
                        ...snapshot.data!,
                      ])
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
    );
  }
}
