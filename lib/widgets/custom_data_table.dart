import 'package:camera_app/widgets/delete_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/app/bloc.dart';
import '../bloc/app/events.dart';
import '../data/models/entry.dart';

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({
    super.key,
    required this.entries,
    required this.title,
  });

  final List<Entry> entries;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: PaginatedDataTable(
        columns: const [
          DataColumn(
            label: Text('#'),
          ),
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Actions'),
          ),
        ],
        source: CustomDataSource(
          entries: entries,
          onSelectChanged: (value) {
            context.push('/$title/${value.id}');
            context.read<AppBloc>().add(ShowEntryEvent(entry: value));
          },
          onDeleteFile: (value) async {
            var result = await showDialog(
              context: context,
              builder: (context) {
                return DeleteAlertDialog(value: value, isEntry: false);
              },
            );
            if (!result || !context.mounted) return;
            if (title.toLowerCase() == 'audio') {
              context.read<AppBloc>().add(DeleteAudioEvent(entry: value));
            } else {
              context.read<AppBloc>().add(DeletePhotoEvent(entry: value));
            }
          },
        ),
        showCheckboxColumn: false,
      ),
    );
  }
}

class CustomDataSource extends DataTableSource {
  final List<Entry> entries;
  void Function(Entry value) onSelectChanged;
  void Function(Entry value) onDeleteFile;

  CustomDataSource({
    required this.entries,
    required this.onSelectChanged,
    required this.onDeleteFile,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      onSelectChanged: (_) => onSelectChanged(entries[index]),
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(entries[index].name)),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: entries[index].isDeleted
                    ? null
                    : () {
                        onDeleteFile(entries[index]);
                      },
                style: IconButton.styleFrom(
                  foregroundColor: Colors.red,
                  disabledForegroundColor: Colors.grey,
                ),
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => entries.length;

  @override
  int get selectedRowCount => 0;
}
