// booking_model.dart

class Booking {
  final String? id;
  final int cabinId;
  final DateTime fromDate;
  final DateTime endDate;
  final int guestCount;
  final double cabinPrice;
  final String status;

  Booking({
    this.id,
    required this.cabinId,
    required this.fromDate,
    required this.endDate,
    required this.guestCount,
    required this.cabinPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString(),
      cabinId: int.tryParse(json['cabinId'].toString()) ?? 0,
      fromDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      guestCount: json['numGuests'],
      cabinPrice: (json['cabinPrice'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      if (id != null) 'id': id,
      'cabinId': cabinId,
      'startDate': fromDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numGuests': guestCount,
      'cabinPrice': cabinPrice,
      'status': status,
    };
    return data;
  }

  double get totalPrice {
    final nights = endDate.difference(fromDate).inDays;
    return nights * cabinPrice;
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
      cabinId: (cabinId ?? this.cabinId) as int,
      fromDate: fromDate ?? this.fromDate,
      endDate: toDate ?? this.endDate,
      guestCount: guestCount ?? this.guestCount,
      cabinPrice: pricePerNight ?? this.cabinPrice,
      status: status ?? this.status,
    );
  }
}
