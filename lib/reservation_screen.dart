// reservation_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'booking_model.dart';
import 'booking_service.dart';
import 'main_navigation_screen.dart';
import 'supabase_service.dart';
import 'cabin_model.dart';

class ReservationScreen extends StatefulWidget {
  final String cabinId;
  final int maxCapacity;

  const ReservationScreen({
    required this.cabinId,
    required this.maxCapacity,
    Key? key,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  int _guestCount = 1;
  String _specialRequests = '';
  Cabin? selectedCabin;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadCabin();
  }

  Future<void> _checkAuthAndLoadCabin() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
            (route) => false,
      );
      return;
    }

    final supabaseService = Provider.of<BookingService>(context, listen: false).supabaseService;
    try {
      final cabin = await supabaseService.getCabinById(widget.cabinId);
      setState(() {
        selectedCabin = cabin;
        isLoading = false;
      });
    } catch (e) {
      print('[ERROR] Failed to load cabin: $e');
      setState(() => isLoading = false);
    }
  }

  int get _numberOfNights {
    if (_selectedFromDate != null && _selectedToDate != null) {
      return _selectedToDate!.difference(_selectedFromDate!).inDays;
    }
    return 0;
  }

  double get _totalPrice => _numberOfNights * (selectedCabin?.regularPrice ?? 0);

  Future<void> _pickDateRange(BuildContext context, bool isFrom) async {
    DateTime initialDate = isFrom
        ? (_selectedFromDate ?? DateTime.now())
        : (_selectedToDate ?? DateTime.now().add(const Duration(days: 1)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _selectedFromDate = picked;
          if (_selectedToDate != null && _selectedToDate!.isBefore(picked)) {
            _selectedToDate = null;
          }
        } else {
          if (_selectedFromDate != null && picked.isAfter(_selectedFromDate!)) {
            _selectedToDate = picked;
          }
        }
      });
    }
  }

  Future<void> _reserveCabin() async {
    if (selectedCabin == null) return;

    final bookingService = Provider.of<BookingService>(context, listen: false);
    final supabaseService = bookingService.supabaseService;
    final userId = supabaseService.auth.currentUser?.id ?? '';

    try {
      final cabinId = int.tryParse(selectedCabin!.id.toString()) ?? 0;
      if (cabinId == 0) {
        throw Exception('Invalid cabin ID');
      }

      final totalPrice = _numberOfNights * selectedCabin!.regularPrice;

      final booking = Booking(
        cabinId: cabinId,
        fromDate: _selectedFromDate!,
        endDate: _selectedToDate!,
        guestCount: _guestCount,
        cabinPrice: totalPrice, // ✅ Store total price here
        status: 'confirmed',
      );

      await bookingService.addBooking(booking);
      if (userId.isNotEmpty) {
        await bookingService.loadUserBookings(userId);
      }
      Navigator.pop(context, true);
    } catch (e) {
      print('[ERROR] Booking failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (selectedCabin == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load cabin details.', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Cabin', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text("Select your dates:", style: TextStyle(fontSize: 18, color: Colors.white)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickDateRange(context, true),
                    child: Text(
                      _selectedFromDate == null
                          ? 'From Date'
                          : 'From: ${_selectedFromDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedFromDate == null
                        ? null
                        : () => _pickDateRange(context, false),
                    child: Text(
                      _selectedToDate == null
                          ? 'To Date'
                          : 'To: ${_selectedToDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("How many guests?", style: TextStyle(fontSize: 18, color: Colors.white)),
            DropdownButton<int>(
              value: _guestCount,
              items: List.generate(widget.maxCapacity, (i) => i + 1)
                  .map((count) => DropdownMenuItem(
                value: count,
                child: Text('$count guest${count > 1 ? 's' : ''}', style: TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _guestCount = value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text("Special Requests:", style: TextStyle(fontSize: 18, color: Colors.white)),
            TextField(
              maxLines: 3,
              onChanged: (value) => _specialRequests = value,
              decoration: const InputDecoration(
                hintText: 'Enter any special requests...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (_numberOfNights > 0)
              Text(
                'Total Price for $_numberOfNights night(s): \$$_totalPrice',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: _selectedFromDate != null &&
                  _selectedToDate != null &&
                  _selectedToDate!.isAfter(_selectedFromDate!)
                  ? _reserveCabin
                  : null,
              child: const Text('Reserve Now', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}