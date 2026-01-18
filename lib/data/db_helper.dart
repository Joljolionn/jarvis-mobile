import 'package:jarvis_mobile/core/env_config.dart';
import 'package:jarvis_mobile/data/dtos/item_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), EnvConfig.dbRoute),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, num INTEGER, completed BOOLEAN)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertItem(ItemDto item) async {
    final db =
        await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ItemDto>> items() async {
    final db = await database;

    final List<Map<String, Object?>> itemMaps = await db.query('items');

    return itemMaps.map((itemMap) => ItemDto.fromMap(itemMap)).toList();
  }
}
