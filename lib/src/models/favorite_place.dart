import 'dart:io';

enum PlaceCategory { home, work, travel, relax, view, sports, activity, other }

class Address {
  const Address({
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
  });
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;

  @override
  String toString() {
    var content = "${city} ${state} ${country} ${zipcode}";
    return content;
  }
}

class FavoritePlace {
  FavoritePlace({
    required this.id,
    required this.name,
    required this.category,
    this.address,
    required this.image,
  });
  final String id;
  final String name;
  final PlaceCategory category;
  final File image;
  Address? address;
}
