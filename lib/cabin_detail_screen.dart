import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'reservation_screen.dart';
import 'main_navigation_screen.dart';

class CabinDetailScreen extends StatefulWidget {
  final String cabinId;
  const CabinDetailScreen({required this.cabinId, Key? key}) : super(key: key);

  @override
  _CabinDetailScreenState createState() => _CabinDetailScreenState();
}

class _CabinDetailScreenState extends State<CabinDetailScreen> {
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Cabin Details',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/cabin.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Cabin 001',
              style: GoogleFonts.josefinSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _showFullDescription
                  ? 'Discover the ultimate luxury getaway for couples in the cozy wooden cabin OOI. '
                  'Nestled in a picturesque forest, this stunning cabin offers a secluded and intimate retreat. '
                  'Inside, enjoy modern high-quality wood interiors, a comfortable seating area, a fireplace, '
                  'king-size bed, and a luxurious bathroom with a rainfall shower. The cabin features floor-to-ceiling '
                  'windows offering breathtaking views of the surrounding mountains.'
                  : 'Discover the ultimate luxury getaway for couples in the cozy wooden cabin OOI. '
                  'Nestled in a picturesque forest, this stunning cabin offers a secluded and intimate retreat...',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _showFullDescription = !_showFullDescription),
              child: Text(
                _showFullDescription ? 'Show less' : 'Show more',
                style: GoogleFonts.josefinSans(
                  color: Colors.brown[200],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'For up to 2 guests',
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '• Located in the heart of the Dolomites (Italy)',
              style: GoogleFonts.josefinSans(
                color: Colors.white,
              ),
            ),
            Text(
              '• Privacy 100% guaranteed',
              style: GoogleFonts.josefinSans(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '\$250 / night',
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                if (!authService.isLoggedIn) {
                  final loggedIn = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainNavigationScreen(initialIndex: 2),
                      settings: RouteSettings(arguments: {
                        'fromReservation': true,
                        'cabinId': widget.cabinId,
                      }),
                    ),
                  );

                  if (loggedIn == true) {
                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ReservationScreen(cabinId: widget.cabinId),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                } else {
                  await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ReservationScreen(cabinId: widget.cabinId),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                }
              },
              child: Text(
                'Reserve Now',
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 0,
        onTap: (index) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainNavigationScreen(initialIndex: index)),
              (route) => false,
        ),
        selectedItemColor: Colors.brown[200],
        unselectedItemColor: Colors.grey,
        items: [
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