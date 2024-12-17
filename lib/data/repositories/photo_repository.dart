import 'dart:io';

import 'package:camera_app/data/services/sqlite_database.dart';

import '../models/entry.dart';

class PhotoRepository {
  SqliteDatabase sqliteDatabase = SqliteDatabase.instance;
  final table = 'photos';

  Future<Entry> add(Entry entry) async {
    return await sqliteDatabase.insertEntry(entry, table);
  }

  Future<List<Entry>> getAll() async {
    return await sqliteDatabase.getAll(table);
  }

  Future<void> deleteFile(Entry entry) async {
    if (await File(entry.path).exists()) {
      await File(entry.path).delete();
    }
    await sqliteDatabase.deleteFile(entry, table);
  }

  Future<void> deleteEntry(int id) async {
    await sqliteDatabase.deleteEntry(id, table);
  }

  Future<void> deleteAllWithoutFile() async {
    await sqliteDatabase.deleteAllWithNoFile(table);
  }
}