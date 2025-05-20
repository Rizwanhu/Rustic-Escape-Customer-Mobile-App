import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'auth_service.dart';
import 'booking_service.dart';

void main() => runApp(WildOasisApp());

class WildOasisApp extends StatelessWidget {
  final AuthService authService = AuthService();
  final BookingService bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookingService>.value(value: bookingService),
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'The Wild Oasis',
        theme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.josefinSansTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: Colors.brown,
        ),
        home: SplashScreen(),
      ),
    );
  }
}