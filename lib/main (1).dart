import 'package:flutter/material.dart';
import 'splash_screen.dart';


void main() => runApp(WildOasisApp());

class WildOasisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Wild Oasis',
      theme: ThemeData.dark(),
      home: SplashScreen(), // Start with splash
    );
  }
}