import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:recipe_app/Backend/db_helper.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  // Define a behavior subject
  final _authStateSubject = BehaviorSubject<bool>.seeded(false);

  // Use the singleton database instance
  final dbHelper = DatabaseHelper.instance;

  // This is to store the current user data
  Map<String, dynamic>? _currentUser;

  // This is to expose the authetication state to be used in StreamBuilder
  // This is just a getter with a shorthand synthax for brevity since
  // there is only one expression
  Stream<bool> get authState => _authStateSubject.stream;

  bool get isLoggedIn => _authStateSubject.value;

  // Register new user
  Future<bool> register(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    int userID = await dbHelper.registerUser(username, hashedPassword);

    if (userID > 0) {
      await _populateDefaultRecipes(userID);
      return true;
    } else {
      return false;
    }
  }

  // Initialize the database
  Future<void> _populateDefaultRecipes(int userId) async {
    final String response =
        await rootBundle.loadString('Assets/default_recipes.json');
    final List<dynamic> data = json.decode(response);

    for (var recipe in data) {
      await dbHelper.addRecipe(
        userId,
        recipe['category'],
        recipe['title'],
        recipe['description'],
        recipe['ingredients'],
        recipe['instructions'],
      );
    }
  }

  // Login method
  Future<bool> login(String username, String password) async {
    final hashedPassword = _hashPassword(password);
    final user = await dbHelper.loginUser(username, hashedPassword);
    if (user != null) {
      _currentUser = user;
      _authStateSubject.add(true); // Emit logged-in state
      return true;
    }
    return false;
  }

  // Logout method
  void logout() {
    _currentUser = null;
    _authStateSubject.add(false);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    return _currentUser;
  }

  int? getCurrentUserId() {
    return _currentUser?['id'];
  }

  // Hash the password
  String _hashPassword(String password) {
    // For simplicity, we're just reversing the string.
    // Replace this with a proper hashing algorithm like bcrypt or SHA-256.
    return password.split('').reversed.join('');
  }

  // To avoid memory leak, we must gracefully close any Streams
  void dispose() {
    _authStateSubject.close();
  }
}
