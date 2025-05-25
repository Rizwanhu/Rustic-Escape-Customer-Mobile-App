import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- Added import for UserAttributes
import 'auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Change Password', style: GoogleFonts.josefinSans()),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: oldPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter old password' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter new password';
                  if (val.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (val) {
                  if (val != newPasswordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  if (!_formKey.currentState!.validate()) return;

                  setState(() => isLoading = true);

                  final user = authService.client.auth.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No user logged in')),
                    );
                    setState(() => isLoading = false);
                    return;
                  }

                  // Re-authenticate user by signing in again with old password
                  final signInResponse =
                  await authService.client.auth.signInWithPassword(
                    email: user.email!,
                    password: oldPasswordController.text,
                  );

                  if (signInResponse.user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Old password incorrect')),
                    );
                    setState(() => isLoading = false);
                    return;
                  }

                  try {
                    await authService.client.auth.updateUser(
                      UserAttributes(
                          password: newPasswordController.text),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Password changed successfully')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text('Password update failed: $e')),
                    );
                  }

                  setState(() => isLoading = false);
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[400],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
