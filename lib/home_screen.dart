import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cabin_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Our Luxury Cabins',
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
              'Cozy yet luxurious cabins...Welcome to paradise.',
              style: GoogleFonts.josefinSans(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(
                    'All Cabins',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
                Chip(
                  label: Text(
                    '1–3 guests',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
                Chip(
                  label: Text(
                    '4–7 guests',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
                Chip(
                  label: Text(
                    '8–12 guests',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.grey[800],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildCabinCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCabinCard(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/cabin.jpg'),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cabin 001',
                  style: GoogleFonts.josefinSans(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
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
                SizedBox(height: 8),
                Text(
                  '\$250 / night',
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CabinDetailScreen(cabinId: '001'),
                      ),
                    );
                  },
                  child: Text(
                    'Details & reservation →',
                    style: GoogleFonts.josefinSans(
                      color: Colors.purple[200],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}