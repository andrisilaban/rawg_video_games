import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game.dart';

class DBService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'favorites.db'),
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            name TEXT,
            background_image TEXT,
            rating REAL,
            released TEXT,         -- Add released column
            description_raw TEXT   -- Add description_raw column
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
            ALTER TABLE favorites ADD COLUMN released TEXT;
            ALTER TABLE favorites ADD COLUMN description_raw TEXT;
          ''');
        }
      },
    );
  }

  Future<void> addFavorite(Game game) async {
    final db = await database;
    await db.insert('favorites', game.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Game>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
