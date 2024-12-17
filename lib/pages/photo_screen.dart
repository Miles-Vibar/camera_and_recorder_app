import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/events.dart';
import '../bloc/app/state.dart';
import '../data/models/entry.dart';
import '../widgets/custom_data_table.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  List<Entry> entries = [];
  bool reload = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        if (current is GotAllPhotos) {
          entries = current.entries;
        }
        if (current is AddPhotoState) {
          entries.add(current.entry);
        }
        return current is AddPhotoState || current is GotAllPhotos;
      },
      builder: (context, state) {
        if (entries.isEmpty && reload) {
          reload = false;
          context.read<AppBloc>().add(GetAllPhotosEvent());
        }

        return CustomDataTable(
          entries: entries,
          title: 'photos',
        );
      },
    );
  }
}
