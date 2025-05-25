//guest_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ChangePasswordScreen.dart';
import 'PersonalInformationScreen.dart';
import 'account_settings_screens.dart';
import 'auth_service.dart';
import 'auth_wrapper.dart';
import 'booking_model.dart';
import 'booking_service.dart';
import 'main_navigation_screen.dart';

class GuestDashboardScreen extends StatefulWidget {
  @override
  _GuestDashboardScreenState createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  late BookingService bookingService;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookingService = Provider.of<BookingService>(context, listen: false);
    final userId = bookingService.supabaseService.auth.currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      await bookingService.loadUserBookings(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.supabaseService.auth.currentUser?.id ?? '';
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Guest Area',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final authService = AuthWrapper.of(context);
                await authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigationScreen(initialIndex: 2),
                    settings: RouteSettings(name: 'guest'),
                  ),
                      (Route<dynamic> route) => false,
                );
              }
          ),
        ],
      ),
      body: Consumer<BookingService>(
        builder: (context, bookingService, child) {
          return RefreshIndicator(
              onRefresh: () => bookingService.loadUserBookings(userId),
          child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                SizedBox(height: 24),
                _buildUpcomingBookings(context, bookingService),
                SizedBox(height: 24),
                _buildPastBookings(context, bookingService),
                SizedBox(height: 24),
                _buildAccountSettings(context),
              ],
            ),
          ));
        },
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: GoogleFonts.josefinSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage your bookings and account details',
          style: GoogleFonts.josefinSans(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookings(BuildContext context, BookingService bookingService) {
    final upcomingBookings = bookingService.upcomingBookings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Bookings',
          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ...upcomingBookings.map((b) => Card(
          color: Colors.grey[800],
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_work, color: Colors.brown[400]),
                  title: Text(
                    'Cabin ID: ${b.cabinId}',
                    style: GoogleFonts.josefinSans(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${_formatDate(b.fromDate)} → ${_formatDate(b.endDate)}',
                    style: GoogleFonts.josefinSans(color: Colors.grey[400]),
                  ),
                  trailing: Chip(
                    label: Text(
                      'Confirmed',
                      style: GoogleFonts.josefinSans(color: Colors.white),
                    ),
                    backgroundColor: Colors.green[800],
                  ),
                ),
                Divider(color: Colors.grey[700]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _showBookingDetails(context, b),
                      child: Text(
                        'VIEW DETAILS',
                        style: GoogleFonts.josefinSans(color: Colors.brown[200]),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _showCancelConfirmation(context, bookingService, b.id!),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.josefinSans(color: Colors.red[400]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )).toList(),
        if (upcomingBookings.isEmpty)
          Text(
            'No upcoming bookings',
            style: GoogleFonts.josefinSans(color: Colors.grey[400]),
          ),
      ],
    );
  }

  Widget _buildPastBookings(BuildContext context, BookingService bookingService) {
    final pastBookings = bookingService.pastBookings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Bookings',
          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        if (pastBookings.isEmpty)
          Text(
            'No past bookings',
            style: GoogleFonts.josefinSans(color: Colors.grey[400]),
          ),
        ...pastBookings.map((booking) => Card(
          color: Colors.grey[800],
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_work, color: Colors.brown[400]),
                  subtitle: Text(
                    '${_formatDate(booking.fromDate)} - ${_formatDate(booking.endDate)}',
                    style: GoogleFonts.josefinSans(color: Colors.grey[400]),
                  ),
                  trailing: Chip(
                    label: Text(
                      'Completed',
                      style: GoogleFonts.josefinSans(color: Colors.white),
                    ),
                    backgroundColor: Colors.green[800],
                  ),
                ),
                Divider(color: Colors.grey[700]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'VIEW DETAILS',
                        style: GoogleFonts.josefinSans(color: Colors.brown[200]),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'REVIEW',
                        style: GoogleFonts.josefinSans(color: Colors.brown[200]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Settings',
          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Card(
          color: Colors.grey[800],
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person, color: Colors.brown[400]),
                title: Text(
                  'Personal Information',
                  style: GoogleFonts.josefinSans(color: Colors.white),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PersonalInformationScreen()),
                ),
              ),
              Divider(height: 0, color: Colors.grey[700]),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.brown[400]),
                title: Text(
                  'Change Password',
                  style: GoogleFonts.josefinSans(color: Colors.white),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(
          'Booking Details',
          style: GoogleFonts.josefinSans(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/cabin.jpg', height: 150, fit: BoxFit.cover),
              ),
              SizedBox(height: 8),
              Text(
                '${_formatDate(booking.fromDate)} - ${_formatDate(booking.endDate)}',
                style: GoogleFonts.josefinSans(color: Colors.grey[400]),
              ),
              Text(
                '${booking.endDate.difference(booking.fromDate).inDays} night${booking.endDate.difference(booking.fromDate).inDays > 1 ? 's' : ''}',
                style: GoogleFonts.josefinSans(color: Colors.grey[400]),
              ),
              SizedBox(height: 8),
              Text(
                'Guests: ${booking.guestCount}',
                style: GoogleFonts.josefinSans(color: Colors.grey[400]),
              ),
              SizedBox(height: 8),
              Text(
                '\$${booking.totalPrice.toStringAsFixed(2)} total',
                style: GoogleFonts.josefinSans(color: Colors.grey[400]),
              ),
              SizedBox(height: 8),
              Text(
                'Status: ${booking.status.toUpperCase()}',
                style: GoogleFonts.josefinSans(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.josefinSans(color: Colors.brown[200]),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, BookingService bookingService, String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(
          'Cancel Reservation',
          style: GoogleFonts.josefinSans(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to cancel this reservation?',
          style: GoogleFonts.josefinSans(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: GoogleFonts.josefinSans(color: Colors.brown[200]),
            ),
          ),
          TextButton(
            onPressed: () {
              bookingService.cancelBooking(bookingId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reservation cancelled',
                    style: GoogleFonts.josefinSans(),
                  ),
                  backgroundColor: Colors.grey[700],
                ),
              );
            },
            child: Text(
              'Yes',
              style: GoogleFonts.josefinSans(color: Colors.red[400]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}