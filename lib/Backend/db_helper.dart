import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Make a singleton since we only need one instance of the database
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_system.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        name TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        categoryId INTEGER,
        title TEXT NOT NULL,
        description TEXT,
        ingredients TEXT,
        instructions TEXT,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      )
    ''');
  }

  Future<int> registerUser(String username, String password) async {
    Database db = await instance.database;
    return await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm:
          ConflictAlgorithm.ignore, // Prevent duplicate usernames
    );
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    Database db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> addCategory(int userId, String name) async {
    Database db = await instance.database;
    final result = await db.query(
      'categories',
      where: 'userId = ? AND name = ?',
      whereArgs: [userId, name],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return await db.insert(
        'categories',
        {'userId': userId, 'name': name},
      );
    }
  }

  Future<int> addRecipe(int userId, String category, String title,
      String description, String ingredients, String instructions) async {
    int categoryId = await addCategory(userId, category);
    Database db = await instance.database;
    return await db.insert(
      'recipes',
      {
        'userId': userId,
        'categoryId': categoryId,
        'title': title,
        'description': description,
        'ingredients': ingredients,
        'instructions': instructions,
      },
    );
  }

  Future<int> updateRecipeTitle(int recipeId, String title) async {
    Database db = await instance.database;
    return await db.update(
      'recipes',
      {'title': title},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> updateRecipeDescription(int recipeId, String description) async {
    Database db = await instance.database;
    return await db.update(
      'recipes',
      {'description': description},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> updateRecipeIngredients(int recipeId, String ingredients) async {
    Database db = await instance.database;
    return await db.update(
      'recipes',
      {'ingredients': ingredients},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> updateRecipeInstructions(
      int recipeId, String instructions) async {
    Database db = await instance.database;
    return await db.update(
      'recipes',
      {'instructions': instructions},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> deleteRecipe(int recipeId) async {
    Database db = await instance.database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<Map<String, dynamic>>> getCategories(int userId) async {
    Database db = await instance.database;
    return await db.query(
      'categories',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getRecipes(int userId) async {
    Database db = await instance.database;
    return await db.query(
      'recipes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getRecipesByCategory(
      int userId, int categoryId) async {
    Database db = await instance.database;
    return await db.query(
      'recipes',
      where: 'userId = ? AND categoryId = ?',
      whereArgs: [userId, categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> getUserAllRecipes(int userId) async {
    Database db = await instance.database;
    return await db.query(
      'recipes',
      where: 'userId = ? ',
      whereArgs: [userId],
    );
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_system.db');
    print('Database path: $path'); // Debugging: Print the database path
    await databaseFactory.deleteDatabase(path);
    _database = null; // Reset the database instance
    print('Database file deleted'); // Debugging: Confirm deletion
  }
}
