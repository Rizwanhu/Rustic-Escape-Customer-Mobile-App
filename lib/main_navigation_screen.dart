// main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seproject/reservation_screen.dart';
import 'auth_service.dart';
import 'booking_service.dart';
import 'home_screen.dart';
import 'about_screen.dart';
import 'guest_screen.dart';
import 'guest_dashboard_screen.dart';
import 'auth_wrapper.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  MainNavigationScreen({this.initialIndex = 0});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Initialize with the passed value
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final bookingService = Provider.of<BookingService>(context, listen: false);

    // Get navigation arguments (now handling Map instead of bool)
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final fromReservation = routeArgs?['fromReservation'] ?? false;
    final cabinId = routeArgs?['cabinId'] ?? '';

    final List<Widget> _screens = [
      HomeScreen(),
      AboutScreen(),
      authService.isLoggedIn
          ? GuestDashboardScreen()
          : GuestScreen(),
    ];

    void _onItemTapped(int index) {
      if (index == 2 && fromReservation && authService.isLoggedIn) {
        // Return to cabin detail with success flag
        Navigator.pop(context, true);

        // Then immediately open reservation screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationScreen(cabinId: cabinId),
            ),
          );
        });
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    }

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