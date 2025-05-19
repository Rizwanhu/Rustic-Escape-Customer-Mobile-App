// booking_service.dart
import 'package:flutter/material.dart';
import 'booking_model.dart';

class BookingService extends ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get upcomingBookings =>
      _bookings.where((b) => b.status == 'confirmed').toList();

  List<Booking> get pastBookings =>
      _bookings.where((b) => b.status == 'completed').toList();

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners(); // Notify about the change
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: 'cancelled');
      notifyListeners(); // Notify about the change
    }
  }
}