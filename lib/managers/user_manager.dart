import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class UserManager {
  List<User> _users = [];
  User? _activeUser;

  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  List<User> get users => _users;
  User? get activeUser => _activeUser;

  Future<void> loadUsers() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        _users = jsonData.map((userJson) => User.fromJson(userJson)).toList();
      }
    } catch (e) {
      print('Kullanıcılar yüklenirken hata oluştu: $e');
    }
  }

  Future<void> saveUsers() async {
    try {
      final file = await _getLocalFile();
      final List<Map<String, dynamic>> jsonData = _users.map((u) => u.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Kullanıcılar kaydedilirken hata oluştu: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<bool> signUp({required String name, required String email, required String password}) async {
    if (_users.any((u) => u.email == email)) {
      return false;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );
    _users.add(newUser);
    await saveUsers();
    return true;
  }

  Future<bool> signIn({required String email, required String password}) async {
    final matchingUsers = _users.where((u) => u.email == email && u.password == password);
    if (matchingUsers.isNotEmpty) {
      _activeUser = matchingUsers.first;
      return true;
    }
    return false;
  }


  void signOut() {
    _activeUser = null;
  }
}
