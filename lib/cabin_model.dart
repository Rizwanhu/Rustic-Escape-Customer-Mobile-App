// cabin_model.dart
class Cabin {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int maxGuests;
  final double pricePerNight;
  final List<String> features;

  Cabin({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.maxGuests,
    required this.pricePerNight,
    required this.features,
  });
}