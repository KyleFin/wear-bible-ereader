import 'dart:io';

import 'package:android_companion_for_wear_os_ereader/counter/counter.dart';
import 'package:android_companion_for_wear_os_ereader/l10n/l10n.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(context.read<BookshelfRepository>()),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bookshelfRepository = context.read<BookshelfRepository>();
    final cubit = context.read<CounterCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: Center(
        child: StreamBuilder<Iterable<String>>(
          initialData: bookshelfRepository.titlesAndFilepaths.keys,
          stream:
              bookshelfRepository.titlesAndFilepathsStream.map((t) => t.keys),
          builder: (context, snapshot) {
            return Column(
              children: [
                const CounterText(),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['epub'],
                    );

                    // The result will be null, if the user aborted the dialog
                    if (result != null) {
                      await cubit.addBook(File(result.files.first.path!));
                    }
                  },
                  child: const Text('Transfer epub file'),
                ),
                for (final t in snapshot.data!)
                  ElevatedButton(
                    onPressed: () => cubit.deleteBook(t),
                    child: Text('$t (delete)'),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
