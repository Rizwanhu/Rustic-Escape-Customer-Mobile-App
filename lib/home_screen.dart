import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Luxury Cabins'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cozy yet luxurious cabins...Welcome to paradise.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('All Cabins')),
                Chip(label: Text('1–3 guests')),
                Chip(label: Text('4–7 guests')),
                Chip(label: Text('8–12 guests')),
              ],
            ),
            SizedBox(height: 16),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/cabin.jpg'),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cabin 001', style: TextStyle(fontSize: 18)),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16),
                            SizedBox(width: 4),
                            Text('For up to 2 guests'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('\$250 / night'),
                        TextButton(
                          onPressed: () {},
                          child: Text('Details & reservation →'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}