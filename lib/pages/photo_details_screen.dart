import 'dart:io';

import 'package:camera_app/bloc/app/events.dart';
import 'package:camera_app/widgets/delete_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/state.dart';
import '../data/models/entry.dart';

class PhotoDetailsScreen extends StatelessWidget {
  const PhotoDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (prev, curr) => false,
      builder: (context, state) {
        final Entry entry = (state as ShowEntryState).entry;
        return ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (File(entry.path).existsSync())
                  Image.file(File(entry.path))
                else
                  const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Placeholder(),
                  ),
                const SizedBox(
                  height: 8,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Photo: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: entry.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Path: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: entry.path,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (!File(entry.path).existsSync())
                  Center(
                    child: FilledButton.icon(
                      onPressed: () async {
                        var result = await showDialog(context: context, builder: (context) {
                          return DeleteAlertDialog(value: entry, isEntry: true);
                        });

                        if (!result || !context.mounted) return;

                        context.read<AppBloc>().add(
                              DeletePhotoEntryEvent(id: id),
                            );
                        context.pop();
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Delete Entry'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
