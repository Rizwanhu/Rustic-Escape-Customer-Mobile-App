// auth_service.dart
import 'package:flutter/material.dart';

class AuthService extends ValueNotifier<bool> {
  int lastVisitedTab = 0;

  AuthService() : super(false);

  bool get isLoggedIn => value;

  void login() {
    value = true;
    notifyListeners();
  }

  void logout() {
    value = false;
    notifyListeners();
  }

  void updateLastVisitedTab(int index) {
    lastVisitedTab = index;
    notifyListeners();
  }
}