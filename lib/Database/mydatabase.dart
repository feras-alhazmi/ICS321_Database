import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'my_database.db');
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT
      )
    ''');
  }

  static Future<int> insertUser(Map<String, dynamic> user) async {
    final Database db = await database;
    return await db.insert('users', user);
  }

  // Add more CRUD operations as needed
}
