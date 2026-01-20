import 'dart:convert';

import 'package:jarvis_mobile/core/env_config.dart';
import 'package:http/http.dart' as http;
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

  Future<void> insertItem(String name) async {
    final db = await database;
    await db.insert('items', {
      "name": name,
      "num": 1,
      "completed": 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemDto>> getAllItems() async {
    final db = await database;

    final List<Map<String, Object?>> itemMaps = await db.query('items');

    return itemMaps.map((itemMap) => ItemDto.fromMap(itemMap)).toList();
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    int deleted = await db.delete("items", where: "id = ?", whereArgs: [id]);
    return deleted;
  }

  Future<int> updateNumItem(int id, int num) async {
    final db = await database;
    int updated = await db.update(
      "items",
      {"num": num},
      where: "id = ?",
      whereArgs: [id],
    );
    return updated;
  }

  Future<int> toggleCompletedItem(int id, bool completed) async {
    final db = await database;
    int rowsAffected = await db.update(
      "items",
      {"completed": completed},
      where: "id = ?",
      whereArgs: [id],
    );
    return rowsAffected;
  }

  Future<bool> syncDatabase() async {
    try {
      final response = await http.get(
        Uri.parse("${EnvConfig.serverRoute}/all"),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) return false;

      final List<dynamic> data = jsonDecode(response.body);

      final db = await database;

      await db.transaction((txn) async {
        for (var itemJson in data) {
          final item = ItemDto.fromServerMap(itemJson as Map<String, dynamic>);

          await txn.insert(
            "items",
            item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      return true;
    } catch (e) {
     rethrow;
    }
  }
}
