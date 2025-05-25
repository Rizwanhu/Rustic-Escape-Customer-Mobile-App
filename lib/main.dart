import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';

import 'splash_screen.dart';
import 'auth_service.dart';
import 'booking_service.dart';
import 'supabase_service.dart';
import 'reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();

  final supabaseService = SupabaseService();
  final authService = AuthService(supabaseService);
  final bookingService = BookingService(supabaseService: supabaseService);

  runApp(WildOasisApp(
    supabaseService: supabaseService,
    authService: authService,
    bookingService: bookingService,
  ));
}

class WildOasisApp extends StatefulWidget {
  final AuthService authService;
  final BookingService bookingService;
  final SupabaseService supabaseService;

  const WildOasisApp({
    required this.authService,
    required this.bookingService,
    required this.supabaseService,
    Key? key,
  }) : super(key: key);

  @override
  State<WildOasisApp> createState() => _WildOasisAppState();
}

class _WildOasisAppState extends State<WildOasisApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _listenToIncomingLinks();
  }

  void _listenToIncomingLinks() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleUri(uri);
    });
  }


  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      print('Failed to get initial uri: $e');
    }
  }

  void _handleUri(Uri uri) {
    if (uri.path == '/reset-password') {
      final token = uri.queryParameters['access_token'];
      if (token != null && navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(accessToken: token),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseService>.value(value: widget.supabaseService),
        ChangeNotifierProvider<BookingService>.value(value: widget.bookingService),
        ChangeNotifierProvider<AuthService>.value(value: widget.authService),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
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
