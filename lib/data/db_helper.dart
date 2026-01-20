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

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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
    final id = await db.insert('items', {
      "name": name,
      "num": 1,
      "completed": 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    try {
      await http.post(
        Uri.parse("${EnvConfig.serverRoute}/add"),
        headers: _headers,
        body: jsonEncode({"title": name}),
      );
    } catch (e) {
      print("Erro ao sincronizar insert: $e");
    }
  }

  Future<List<ItemDto>> getAllItems() async {
    final db = await database;

    final List<Map<String, Object?>> itemMaps = await db.query('items');

    return itemMaps.map((itemMap) => ItemDto.fromMap(itemMap)).toList();
  }

Future<int> deleteItem(int id) async {
  final db = await database;
  int deleted = await db.delete("items", where: "id = ?", whereArgs: [id]);

  try {
    // Criamos a requisição manualmente para garantir que o body vá junto
    final request = http.Request("DELETE", Uri.parse("${EnvConfig.serverRoute}/delete"));
    
    request.headers.addAll(_headers);
    request.body = jsonEncode({"id": id});

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Deletado no servidor com sucesso");
    } else {
      print("Erro no servidor: ${response.statusCode}");
    }
  } catch (e) {
    print("Erro de rede ao deletar: $e");
  }
  return deleted;
}

  Future<int> updateNumItem(
    int id,
    int num, {
    required bool isIncrement,
  }) async {
    final db = await database;

    // 1. Atualização Local (continua igual)
    int updated = await db.update(
      "items",
      {"num": num},
      where: "id = ?",
      whereArgs: [id],
    );

    // 2. Sincronização com as rotas /increase ou /decrease
    try {
      // Escolhe a rota baseada na ação
      final action = isIncrement ? "increase" : "decrease";

      await http.patch(
        Uri.parse("${EnvConfig.serverRoute}/$action"),
        headers: _headers,
        // O seu Python espera um DTO que contém o ID
        body: jsonEncode({"id": id}),
      );
    } catch (e) {
      print("Erro ao sincronizar num no server: $e");
    }

    return updated;
  }

  Future<int> toggleCompletedItem(int id, bool completed) async {
    final db = await database;
    // 1. Local
    int rowsAffected = await db.update(
      "items",
      {"completed": completed ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );

    // 2. Servidor
    try {
      await http.put(
        Uri.parse("${EnvConfig.serverRoute}/completed"),
        headers: _headers,
        body: jsonEncode({"id": id, "completed": completed}),
      );
    } catch (e) {
      print("Erro ao sincronizar toggle: $e");
    }
    return rowsAffected;
  }

  Future<bool> syncDatabase() async {
    try {
      final response = await http.get(
        Uri.parse("${EnvConfig.serverRoute}/all"),
        headers: _headers,
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
