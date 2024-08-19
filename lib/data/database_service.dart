import 'package:code/model/all_values.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('master.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableAllValues (
            ${AllValuesFields.id} TEXT PRIMARY KEY,
            ${AllValuesFields.originalTime} TEXT,
            ${AllValuesFields.originalStrokeRate} TEXT,
            ${AllValuesFields.sectionLength} TEXT,
            ${AllValuesFields.newTime} TEXT,
            ${AllValuesFields.newStrokeRate} TEXT,
            ${AllValuesFields.newStrokeLength} TEXT, 
            ${AllValuesFields.date} TEXT)''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> addValue(AllValues value) async {
    final db = await instance.database;

    await db.insert(tableAllValues, value.toJson());
    return true;
  }

  Future<List<AllValues>> getValues() async {
    final db = await instance.database;
    final result = await db.query(tableAllValues);
    var test = result.map((json) => AllValues.fromJson(json)).toList();

    return result.map((json) => AllValues.fromJson(json)).toList();
  }

  Future<int> deleteValue(String id) async {
    final db = await instance.database;

    return await db.delete(tableAllValues,
        where: '${AllValuesFields.id} = ?', whereArgs: [id]);
  }
}
