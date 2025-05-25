//guest_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seproject/auth_service.dart';
import 'email_input_screen.dart';
import 'reset_password_screen.dart';
import 'create_account_screen.dart';

import 'google_oauth_client.dart';

class GuestScreen extends StatefulWidget {
  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmailPassword() async {
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final response = await authService.supabaseService.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Login successful')),
        );
        // Navigate to dashboard/home
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🔴 Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Guest Area', style: GoogleFonts.josefinSans(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Sign in to access your guest area',
                  style: GoogleFonts.josefinSans(fontSize: 18, color: Colors.white)),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmailPassword,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Sign In with Email'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                  );
                },
                child: Text('Create an account', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailInputScreen()),
                  );
                },
                child: Text('Forgot password?', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              _GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatefulWidget {
  @override
  State<_GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<_GoogleLoginButton> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    final supabase = Supabase.instance.client;

    try {
      // This launches the OAuth flow - returns true if flow started
      final didStart = await supabase.auth.signInWithOAuth(OAuthProvider.google);

      if (didStart) {
        // OAuth flow started, user will be redirected back after login
        // Optionally, show a message:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please complete sign-in in the browser')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start Google sign-in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signInWithGoogle,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.black,
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/google_logo.png',
            height: 24,
            width: 24,
          ),
          SizedBox(width: 10),
          Text(
            'Continue with Google',
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
