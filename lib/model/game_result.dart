import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GameResult {
  final int? id;
  final String name;
  final int score;
  final double accuracy;
  final String mode; // ✅ أضفنا المود

  GameResult({
    this.id,
    required this.name,
    required this.score,
    required this.accuracy,
    required this.mode, // ✅ هنا كمان
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'accuracy': accuracy,
      'mode': mode, // ✅ أضفنا المود
    };
  }

  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'],
      name: map['name'],
      score: map['score'],
      accuracy: map['accuracy'],
      mode: map['mode'], // ✅ هنا كمان
    );
  }
}

class DatabaseHelper {
  static const _dbName = 'math_game.db';
  static const _dbVersion = 1;
  static const _tableName = 'results';

  static Database? _database;

  // ✅ إنشاء أو فتح قاعدة البيانات
  static Future<Database> get database async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), _dbName);
    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE $_tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    score INTEGER NOT NULL,
    accuracy REAL NOT NULL,
    mode TEXT NOT NULL
  )
''');
      },
    );
    return _database!;
  }

  // ✅ إدخال نتيجة جديدة
  static Future<void> insertResult(GameResult result) async {
    final db = await database;
    await db.insert(
      _tableName,
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ جلب كل النتائج
  static Future<List<GameResult>> getAllResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, orderBy: 'score DESC');

    return maps.map((map) => GameResult.fromMap(map)).toList();
  }

  // ✅ حذف كل النتائج (لو حبيت تعمل Reset)
  static Future<void> clearAllResults() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
