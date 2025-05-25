import 'dart:convert';
import 'package:flutter/cupertino.dart';

class Cabin {
  final int id;  // Changed from String to int to match Booking expectations
  final String name;
  final String description;
  final int maxCapacity;
  final double regularPrice;
  final double discount;
  final String image;

  Cabin({
    required this.id,
    required this.name,
    required this.description,
    required this.maxCapacity,
    required this.regularPrice,
    required this.discount,
    required this.image,
  });

  factory Cabin.fromJson(Map<String, dynamic> json) {
    debugPrint('Cabin JSON: ${jsonEncode(json)}');

    // Handle ID conversion - try parsing as int first, then fallback to 0
    final dynamic idValue = json['id'] ?? json['ID'] ?? json['Id'] ?? 0;
    final int parsedId = idValue is int
        ? idValue
        : int.tryParse(idValue.toString()) ?? 0;

    return Cabin(
      id: parsedId,  // Now using int
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      maxCapacity: (json['maxCapacity'] ?? json['maxcapacity'] ?? 0) as int,
      regularPrice: (json['regularPrice'] ?? json['regularprice'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'maxCapacity': maxCapacity,
      'regularPrice': regularPrice,
      'discount': discount,
      'image': image,
    };
  }
}