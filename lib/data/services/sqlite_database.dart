import 'package:camera_app/data/models/entry.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase {
  static final SqliteDatabase instance = SqliteDatabase
      ._internal();

  static Database? _database;

  SqliteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/camera_app.db';

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE photos(id INTEGER PRIMARY KEY, name TEXT, path TEXT, isDeleted INTEGER)',
        );
        await db.execute(
          'CREATE TABLE audio(id INTEGER PRIMARY KEY, name TEXT, path TEXT, isDeleted INTEGER)',
        );
      },
    );
  }

  Future<Entry> insertEntry(Entry entry, String table) async {
    final db = await database;

    return entry.copywithId(await db.insert(
      table,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ));
  }

  Future<List<Entry>> getAll(String table) async {
    final db = await database;
    final List<Map<String, dynamic>> entries = await db.query(table);
    return entries.map((x) => Entry.fromJson(x)).toList();
  }

  Future<void> deleteEntry(int id, String table) async {
    final db = await database;

    await db.delete(table, where: 'id = $id');
  }

  Future<void> deleteFile(Entry entry, String table) async {
    final db = await database;

    await db.update(table, entry.deleteFile().toMap(), where: 'id = ${entry.id}');
  }

  Future<void> deleteAllWithNoFile(String table) async {
    final db = await database;

    await db.delete(table, where: 'isDeleted = 1');
  }
}