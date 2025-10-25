import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            duration INTEGER,
            reps INTEGER,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE calories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            meal TEXT,
            calories INTEGER,
            date TEXT
          )
        ''');
      },
    );
  }

  // ---------- WORKOUT METHODS ----------
  Future<int> insertWorkout(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('workouts', data);
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return await db.query('workouts', orderBy: 'id DESC');
  }

  Future<void> deleteWorkout(int id) async {
    final db = await database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- CALORIE METHODS ----------
  Future<int> insertCalorie(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('calories', data);
  }

  Future<List<Map<String, dynamic>>> getCalories() async {
    final db = await database;
    return await db.query('calories', orderBy: 'id DESC');
  }

  Future<void> deleteCalorie(int id) async {
    final db = await database;
    await db.delete('calories', where: 'id = ?', whereArgs: [id]);
  }
}
