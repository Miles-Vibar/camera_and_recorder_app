import 'dart:io';

import 'package:camera_app/bloc/app/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/state.dart';
import '../data/models/entry.dart';

class AudioDetailsScreen extends StatefulWidget {
  const AudioDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<AudioDetailsScreen> createState() => _AudioDetailsScreenState();
}

class _AudioDetailsScreenState extends State<AudioDetailsScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

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
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: File(entry.path).existsSync() ?DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        child: AspectRatio(
                          aspectRatio: 5 / 3,
                          child: FilledButton(
                            onPressed: () async {
                              await audioPlayer.setFilePath(entry.path);
                              audioPlayer.play();
                              setState(() {
                                isPlaying = true;
                              });
                              Future.delayed(
                                audioPlayer.duration ??
                                    const Duration(seconds: 0),
                                () {
                                  setState(() {
                                    isPlaying = false;
                                  });
                                },
                              );
                            },
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ) : const Placeholder(),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Audio: ',
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
                      onPressed: () {
                        context.read<AppBloc>().add(
                          DeleteAudioEntryEvent(id: widget.id),
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
