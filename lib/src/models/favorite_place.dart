import 'dart:io';

enum PlaceCategory { home, work, travel, relax, view, sports, activity, other }

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class FavoritePlace {
  FavoritePlace({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.location,
  });
  final String id;
  final String name;
  final PlaceCategory category;
  final File image;

  final PlaceLocation location;
}
