import 'dart:convert';

import 'package:favorite_place_apps/src/models/favorite_place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.setLocation,
  });
  final void Function(PlaceLocation) setLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var _isGettingLocation = false;
  final _apiKey = 'Your-API-Key';
  Widget _previewContent = const Text('No location chosen');

  String _locationImage(PlaceLocation place) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${place.latitude},${place.longitude}&zoom=12&size=${MediaQuery.of(context).size.width.floor()}x160&maptype=roadmap&markers=color:blue%7Clabel:S%7C${place.latitude},${place.longitude}&key=$_apiKey';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$_apiKey');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData["results"][0]["formatted_address"];

    final place = PlaceLocation(
      address: address,
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
    widget.setLocation(
      place,
    );
    setState(() {
      _previewContent = Image.network(_locationImage(place));
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget preview = Center(
      child: _previewContent,
    );

    if (_isGettingLocation) {
      preview = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: preview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text("Select on map"),
            ),
          ],
        )
      ],
    );
  }
}
