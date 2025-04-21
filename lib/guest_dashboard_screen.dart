import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'about_screen.dart';
import 'main_navigation_screen.dart';

class GuestDashboardScreen extends StatelessWidget {
  final int _currentIndex = 2; // Guest Area is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Area'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate back to MainNavigationScreen with home tab selected
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainNavigationScreen(initialIndex: 0)),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            SizedBox(height: 24),
            _buildUpcomingBookings(),
            SizedBox(height: 24),
            _buildPastBookings(),
            SizedBox(height: 24),
            _buildAccountSettings(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index != _currentIndex) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainNavigationScreen(initialIndex: index)),
                  (Route<dynamic> route) => false,
            );
          }
        },
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

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage your bookings and account details',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_work, color: Colors.brown),
                  title: Text('Luxury Mountain Cabin'),
                  subtitle: Text('June 15-20, 2023'),
                  trailing: Chip(
                    label: Text('Confirmed'),
                    backgroundColor: Colors.green[100],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // View details action
                      },
                      child: Text('VIEW DETAILS'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // Cancel booking action
                      },
                      child: Text('CANCEL', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPastBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_work, color: Colors.brown),
                  title: Text('Lakeside Retreat'),
                  subtitle: Text('April 5-10, 2023'),
                  trailing: Chip(
                    label: Text('Completed'),
                    backgroundColor: Colors.blue[100],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // View details action
                      },
                      child: Text('VIEW DETAILS'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        // Leave review action
                      },
                      child: Text('REVIEW'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person, color: Colors.brown),
                title: Text('Personal Information'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to personal info screen
                },
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.brown),
                title: Text('Phone Number'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to phone number screen
                },
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.brown),
                title: Text('Change Password'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to change password screen
                },
              ),
              Divider(height: 0),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.brown),
                title: Text('Notification Preferences'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to notifications screen
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}