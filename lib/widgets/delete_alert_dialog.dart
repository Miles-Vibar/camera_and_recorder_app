import 'package:flutter/material.dart';

import '../data/models/entry.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({
    super.key,
    this.value,
    required this.isEntry,
  });

  final Entry? value;
  final bool isEntry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${value?.name ?? 'all entries without a file'}?"),
      content: Text(
        'Are you sure you want to delete ${isEntry ? (value == null ? 'all entries without a file' : 'this entry') : 'the file ${value?.name ?? 'no name'}'}? This action is irreversible.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('DELETE'),
        ),
      ],
    );
  }
}
