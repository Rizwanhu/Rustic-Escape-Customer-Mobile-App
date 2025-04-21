import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to The Wild Oasis',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Where nature's beauty and comfortable living blend seamlessly...",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Image.asset('assets/about.jpg'),
          ],
        ),
      ),
    );
  }
}