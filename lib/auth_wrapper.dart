// auth_wrapper.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main.dart';

class AuthWrapper {
  static AuthService of(BuildContext context) {
    final WildOasisApp app = context.findAncestorWidgetOfExactType<WildOasisApp>()!;
    return app.authService;
  }
}