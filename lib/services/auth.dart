import 'user.dart';

class AuthLocal {
  static late UserService _userService;

  static void init(UserService service) {
    _userService = service;
  }

  static Future<bool> validate(String username, String password) async {
    final users = await _userService.getUsers();
    try {
      final match = users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
