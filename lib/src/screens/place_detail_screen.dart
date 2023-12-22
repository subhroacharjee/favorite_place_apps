import 'package:favorite_place_apps/src/models/favorite_place.dart';
import 'package:flutter/material.dart';
import 'package:favorite_place_apps/src/util/string_extensions.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});
  final FavoritePlace place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name.capitalizeFirstLetter())),
      body: Stack(children: [
        Image.file(
          place.image,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ]),
    );
  }
}
