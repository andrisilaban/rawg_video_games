import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            name TEXT,
            background_image TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Game game) async {
    final dbClient = await db;
    await dbClient.insert('favorites', game.toMap());
  }

  Future<void> deleteFavorite(int id) async {
    final dbClient = await db;
    await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Game>> getFavorites() async {
    final dbClient = await db;
    final result = await dbClient.query('favorites');
    return result.map((json) => Game.fromJson(json)).toList();
  }
}
