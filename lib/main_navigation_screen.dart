import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'about_screen.dart';
import 'guest_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  MainNavigationScreen({this.initialIndex = 0});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Ensure the initialIndex is within valid range (0 or 1)
    _currentIndex = widget.initialIndex.clamp(0, 1);
  }

  final List<Widget> _screens = [
    HomeScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to GuestScreen instead of showing it in tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GuestScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Guest Area',
          ),
        ],
      ),
    );
  }
}
