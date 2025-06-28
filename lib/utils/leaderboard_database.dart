import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/game_result.dart';

class LeaderboardDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'leaderboard.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            score INTEGER,
            accuracy REAL,
            mode TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertResult(GameResult result) async {
    final db = await database;
    await db.insert('results', result.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<GameResult>> getResults(String mode) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'results',
      where: 'mode = ?',
      whereArgs: [mode],
      orderBy: 'score DESC',
    );

    return List.generate(maps.length, (i) => GameResult.fromMap(maps[i]));
  }
}
