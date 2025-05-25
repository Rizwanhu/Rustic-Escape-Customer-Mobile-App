// booking_screen.dart

import 'package:flutter/material.dart';
import 'booking_model.dart';
import 'supabase_service.dart';

class BookingService extends ChangeNotifier {
  final SupabaseService supabaseService;
  List<Booking> _bookings = [];

  BookingService({required this.supabaseService});

  Future<void> loadUserBookings(String userId) async {
    try {
      final data = await supabaseService.getUserBookings(userId);
      print('[BOOKING SERVICE] Raw booking data: $data');

      _bookings = data.map<Booking>((json) {
        return Booking.fromJson({
          'id': json['id'],
          'cabinId': json['cabinId'],
          'startDate': json['startDate'],
          'endDate': json['endDate'],
          'numGuests': json['numGuests'],
          'cabinPrice': json['cabinPrice'],
          'status': json['status'],
        });
      }).toList();

      notifyListeners();
    } catch (e) {
      print('[BOOKING SERVICE] Error loading bookings: $e');
      rethrow;
    }
  }

  Future<void> addBooking(Booking booking) async {
    try {
      print('[BOOKING SERVICE] Adding booking: ${booking.toJson()}');
      await supabaseService.createBooking(booking.toJson());
      _bookings.add(booking);
      notifyListeners();
    } catch (e) {
      print('[BOOKING SERVICE] Error adding booking: $e');
      rethrow;
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      print('[BOOKING SERVICE] Cancelling booking: $id');
      await supabaseService.cancelBooking(id);
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: 'cancelled');
        notifyListeners();
      }
    } catch (e) {
      print('[BOOKING SERVICE] Error cancelling booking: $e');
      rethrow;
    }
  }

  List<Booking> get upcomingBookings {
    final now = DateTime.now();
    return _bookings.where((booking) =>
    booking.endDate.isAfter(now) &&
        booking.status.toLowerCase() == 'confirmed'
    ).toList();
  }

  List<Booking> get pastBookings {
    final now = DateTime.now();
    return _bookings.where((booking) =>
    booking.endDate.isBefore(now) &&
        booking.status.toLowerCase() == 'confirmed'
    ).toList();
  }

}
