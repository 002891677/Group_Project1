import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/workout.dart';
import '../models/calorie_entry.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;
  Future<Database> get _database async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'fitness.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            sets INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE calories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT NOT NULL,
            calories INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_workouts_date ON workouts(date)');
        await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_calories_date ON calories(date)');
      },
    );
    return _db!;
  }

  String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ---------------- Workouts ----------------
  Future<int> insertWorkout(Workout w) async {
    final db = await _database;
    return db.insert('workouts', w.toMap());
  }

  Future<List<Workout>> getWorkouts({DateTime? forDate}) async {
    final db = await _database;
    if (forDate == null) {
      final rows = await db.query('workouts', orderBy: 'id DESC');
      return rows.map(Workout.fromMap).toList();
    }
    final key = _dateKey(forDate);
    final rows = await db.query('workouts',
        where: 'date = ?', whereArgs: [key], orderBy: 'id DESC');
    return rows.map(Workout.fromMap).toList();
  }

  Future<int> deleteWorkout(int id) async {
    final db = await _database;
    return db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> totalWorkoutsForDate(DateTime date) async {
    final db = await _database;
    final key = _dateKey(date);
    final x = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM workouts WHERE date = ?', [key]),
    );
    return x ?? 0;
  }

  // ---------------- Calories ----------------
  Future<int> insertCalorie(CalorieEntry c) async {
    final db = await _database;
    return db.insert('calories', c.toMap());
  }

  Future<List<CalorieEntry>> getCalories({DateTime? forDate}) async {
    final db = await _database;
    if (forDate == null) {
      final rows = await db.query('calories', orderBy: 'id DESC');
      return rows.map(CalorieEntry.fromMap).toList();
    }
    final key = _dateKey(forDate);
    final rows = await db.query('calories',
        where: 'date = ?', whereArgs: [key], orderBy: 'id DESC');
    return rows.map(CalorieEntry.fromMap).toList();
  }

  Future<int> deleteCalorie(int id) async {
    final db = await _database;
    return db.delete('calories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> totalCaloriesForDate(DateTime date) async {
    final db = await _database;
    final key = _dateKey(date);
    final x = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COALESCE(SUM(calories),0) FROM calories WHERE date = ?',
          [key]),
    );
    return x ?? 0;
  }
}
