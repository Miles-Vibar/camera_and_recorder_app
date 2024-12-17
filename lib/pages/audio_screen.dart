import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/events.dart';
import '../bloc/app/state.dart';
import '../data/models/entry.dart';
import '../widgets/custom_data_table.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  List<Entry> entries = [];
  bool reload = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        if (current is GotAllAudio) {
          entries = current.entries;
        }
        if (current is AddAudioState) {
          entries.add(current.entry);
        }
        return current is AddAudioState || current is GotAllAudio;
      },
      builder: (context, state) {
        if (entries.isEmpty && reload) {
          reload = false;
          context.read<AppBloc>().add(GetAllAudioEvent());
        }

        return CustomDataTable(
          entries: entries,
          title: 'audio',
        );
      },
    );
  }
}
