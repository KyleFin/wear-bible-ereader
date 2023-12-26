import 'dart:io';

import 'package:android_companion_for_wear_os_ereader/transfer/transfer.dart';
import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransferCubit(context.read<BookshelfRepository>()),
      child: const TransferView(),
    );
  }
}

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookshelfRepository = context.read<BookshelfRepository>();
    final cubit = context.read<TransferCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reader for Wear OS'),
      ),
      body: Center(
        child: StreamBuilder<Iterable<String>>(
          initialData: bookshelfRepository.titlesAndFilepaths.keys,
          stream:
              bookshelfRepository.titlesAndFilepathsStream.map((t) => t.keys),
          builder: (context, snapshot) {
            final titles = snapshot.data!.toList();
            return ListView.separated(
              itemCount: titles.length,
              itemBuilder: (BuildContext context, int index) {
                final title = titles[index];
                return ListTile(
                  title: Text(title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cubit.deleteBook(title),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.outline,
        child: ElevatedButton(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload),
              Text('Copy epub file to watch'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
