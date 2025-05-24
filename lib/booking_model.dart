// booking_model.dart
class Booking {
  final String id;
  final String cabinId;
  final String cabinName;
  final DateTime fromDate;
  final DateTime toDate;
  final int guestCount;
  final double pricePerNight;
  final String status;

  Booking({
    required this.id,
    required this.cabinId,
    required this.cabinName,
    required this.fromDate,
    required this.toDate,
    required this.guestCount,
    this.pricePerNight = 250, // Default price per night
    this.status = 'confirmed',
  });

  // Add a computed property for total price
  double get totalPrice {
    final nights = toDate.difference(fromDate).inDays;
    return nights * pricePerNight;
  }

  Booking copyWith({
    String? id,
    String? cabinId,
    String? cabinName,
    DateTime? fromDate,
    DateTime? toDate,
    int? guestCount,
    double? pricePerNight,
    String? status,
  }) {
    return Booking(
      id: id ?? this.id,
      cabinId: cabinId ?? this.cabinId,
      cabinName: cabinName ?? this.cabinName,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      guestCount: guestCount ?? this.guestCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      status: status ?? this.status,
    );
  }
}