import 'package:chat_app_freese/models/user.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User _user;

  User get user => _user;

  AuthProvider(User currentUser) {
    _user = currentUser;
    notifyListeners();
  }
}
