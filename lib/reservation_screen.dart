import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'booking_model.dart';
import 'booking_service.dart';
import 'main_navigation_screen.dart';

class ReservationScreen extends StatefulWidget {
  final String cabinId;
  const ReservationScreen({required this.cabinId, Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final double _pricePerNight = 250;
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  int _guestCount = 1;
  String _specialRequests = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (!authService.isLoggedIn) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigationScreen(
              initialIndex: 2,
            ),
            settings: RouteSettings(arguments: {
              'fromReservation': true,
              'cabinId': widget.cabinId,
            }),
          ),
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalNights = _selectedFromDate != null && _selectedToDate != null
        ? _selectedToDate!.difference(_selectedFromDate!).inDays
        : 0;
    final totalPrice = totalNights * _pricePerNight;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Reserve Cabin',
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
              'Reserve OOI today. Pay on arrival',
              style: GoogleFonts.josefinSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildLoginInfo(),
            SizedBox(height: 20),
            _buildDateRangeSelector(context),
            SizedBox(height: 20),
            _buildGuestSelector(),
            SizedBox(height: 20),
            _buildSpecialRequests(),
            SizedBox(height: 30),
            _buildReservationSummary(totalNights, totalPrice),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Logged in as',
          style: GoogleFonts.josefinSans(color: Colors.grey[400]),
        ),
        Text(
          'Anonymous',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dates',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickDate(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _selectedFromDate == null
                      ? 'From'
                      : 'From: ${_formatDate(_selectedFromDate!)}',
                  style: GoogleFonts.josefinSans(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedFromDate != null
                    ? () => _pickDate(context, false)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _selectedToDate == null
                      ? 'To'
                      : 'To: ${_formatDate(_selectedToDate!)}',
                  style: GoogleFonts.josefinSans(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? DateTime.now() : _selectedFromDate!.add(Duration(days: 1));
    final firstDate = isStartDate ? DateTime.now() : _selectedFromDate!.add(Duration(days: 1));
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.white,
              surface: Colors.grey[800]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedFromDate = pickedDate;
          _selectedToDate = null;
        } else {
          _selectedToDate = pickedDate;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  Widget _buildGuestSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many guests?',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: DropdownButton<int>(
            value: _guestCount,
            dropdownColor: Colors.grey[800],
            style: GoogleFonts.josefinSans(color: Colors.white),
            underline: SizedBox(),
            isExpanded: true,
            items: List.generate(8, (i) => i + 1)
                .map((value) => DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value guest${value > 1 ? "s" : ""}',
                style: GoogleFonts.josefinSans(),
              ),
            ))
                .toList(),
            onChanged: (value) => setState(() => _guestCount = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anything we should know about your stay?',
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Any pets, allergies, special requirements, etc.?',
          style: GoogleFonts.josefinSans(color: Colors.grey[400]),
        ),
        SizedBox(height: 10),
        TextField(
          maxLines: 3,
          style: GoogleFonts.josefinSans(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.brown[400]!),
            ),
            hintText: 'Enter your special requests...',
            hintStyle: GoogleFonts.josefinSans(color: Colors.grey[500]),
          ),
          onChanged: (value) => setState(() => _specialRequests = value),
        ),
      ],
    );
  }

  Widget _buildReservationSummary(int totalNights, double totalPrice) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$$_pricePerNight / night',
                style: GoogleFonts.josefinSans(color: Colors.white),
              ),
              if (totalNights > 0)
                Text(
                  '$totalNights night${totalNights > 1 ? "s" : ""}',
                  style: GoogleFonts.josefinSans(color: Colors.white),
                ),
              Text(
                'TOTAL: \$${totalPrice.toStringAsFixed(2)}',
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _selectedFromDate != null && _selectedToDate != null
              ? () async {
            final bookingService = Provider.of<BookingService>(context, listen: false);
            final booking = Booking(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              cabinId: widget.cabinId,
              cabinName: 'Cabin ${widget.cabinId}',
              fromDate: _selectedFromDate!,
              toDate: _selectedToDate!,
              guestCount: _guestCount,
            );

            bookingService.addBooking(booking);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Reservation submitted successfully!',
                  style: GoogleFonts.josefinSans(),
                ),
                backgroundColor: Colors.grey[700],
              ),
            );

            Navigator.pop(context);
          }
              : null,
          child: Text(
            'Reserve Now',
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}