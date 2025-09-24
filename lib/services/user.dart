import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  static const _key = 'users';
  List<User> _users = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _users = jsonList.map((e) => User.fromJson(e)).toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_users.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<List<User>> getUsers() async {
    return _users;
  }

  Future<void> createUser(User user) async {
    final newUser = user.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _users.add(newUser);
    await _save();
  }

  Future<void> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      await _save();
    }
  }

  Future<void> deleteUser(String id) async {
    _users.removeWhere((u) => u.id == id);
    await _save();
  }
}
