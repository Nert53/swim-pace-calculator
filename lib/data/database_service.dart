import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> getDataBase() async {
    final String databaseDirPath = await getDatabasesPath();
    final String databasePath = join(databaseDirPath, "master.db");
    final database = await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE saved_values (id INTEGER PRIMARY KEY, time TEXT, date TEXT)");
    });

    return database;
  }
}
