import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wear_os_bible_ereader/counter/counter.dart';
import 'package:wear_os_bible_ereader/epub/epub.dart';
import 'package:wear_os_bible_ereader/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PositionCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    return const Scaffold(body: NavigationList()
        // EpubWidget(
        //   filename: 'bofm.epub',
        // ),
        //     SizedBox.expand(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () => context.read<PositionCubit>(), //.increment(),
        //         child: const Icon(Icons.add),
        //       ),
        //       const SizedBox(height: 10),
        //       Text(l10n.libraryAppBarTitle),
        //       const CounterText(),
        //       const SizedBox(height: 10),
        //       ElevatedButton(
        //         onPressed: () => context.read<PositionCubit>(), //.decrement(),
        //         child: const Icon(Icons.remove),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

class NavigationList extends StatelessWidget {
  const NavigationList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PositionCubit, PositionCubitState>(
      builder: (context, state) {
        final cubit = context.read<PositionCubit>();
        return state.bookTitle == null
            ? ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final k in titleToFilename.keys)
                    ElevatedButton(
                      onPressed: () => cubit.openBook(k),
                      child: Text(k),
                    ),
                  const SizedBox(height: 10),
                  Text(l10n.libraryAppBarTitle),
                  const CounterText(),
                  const SizedBox(height: 10),
                ],
              )
            : state.bookIsLoading
                ? const Text('Loading')
                :
                // EpubViewTableOfContents()
                ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final c in cubit.chapters())
                        ElevatedButton(
                          onPressed: () => cubit.openBook(c),
                          child: Text(c),
                        ),
                      const SizedBox(height: 10),
                      Text(l10n.libraryAppBarTitle),
                      const CounterText(),
                      const SizedBox(height: 10),
                    ],
                  );
      },
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
