import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalInformationScreen extends StatefulWidget {
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final nationalIDController = TextEditingController();
  final nationalityController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  bool _hasLoaded = false; // to prevent multiple loads in didChangeDependencies

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadGuestInfo();
    }
  }

  Future<void> _loadGuestInfo() async {
    final supabaseService =
    Provider.of<SupabaseService>(context, listen: false);

    final guestInfo = await supabaseService.getGuestInfo();

    if (guestInfo != null) {
      fullNameController.text = guestInfo['fullName'] ?? '';
      nationalIDController.text = guestInfo['nationalID'] ?? '';
      nationalityController.text = guestInfo['nationality'] ?? '';
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    nationalIDController.dispose();
    nationalityController.dispose();
    super.dispose();
  }

  Future<void> _savePersonalInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    final supabaseService =
    Provider.of<SupabaseService>(context, listen: false);

    try {
      await supabaseService.updateGuestInfo(
        fullName: fullNameController.text.trim(),
        nationalID: nationalIDController.text.trim(),
        nationality: nationalityController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Information saved successfully')),
      );

      Navigator.of(context).pop(); // Close screen after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save info: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter full name' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: nationalIDController,
                decoration: InputDecoration(labelText: 'National ID'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter National ID' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: nationalityController,
                decoration: InputDecoration(labelText: 'Nationality'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter nationality' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : _savePersonalInfo,
                child: isSaving
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
