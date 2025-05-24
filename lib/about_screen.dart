import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'About Us',
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
            Text(
              'Welcome to The Wild Oasis',
              style: GoogleFonts.josefinSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Where nature's beauty and comfortable living blend seamlessly. Hidden away in the heart of the Italian Dolomites, this is your paradise away from home. But it's not just about the luxury cabins. It's about the experience of reconnecting with nature and enjoying simple pleasures with family.",
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/about.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              'Our 8 luxury cabins provide a cozy base, but the real freedom and peace you\'ll find in the surrounding mountains. Wander through lush forests, breathe in the fresh air, and watch the stars twinkle above from the warmth of a campfire or your hot tub.',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This is where memorable moments are made, surrounded by nature\'s splendor. It\'s a place to slow down, relax, and feel the joy of being together in a beautiful setting.',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      // Removed the bottomNavigationBar since it's already provided by MainNavigationScreen
    );
  }
}