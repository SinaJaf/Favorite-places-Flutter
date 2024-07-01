import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, this.locationCallback});

  final void Function(PlaceLocation)? locationCallback;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation != null) {
      final lat = _pickedLocation!.latitude;
      final lng = _pickedLocation!.longitude;
      return "https://api.tomtom.com/map/1/staticimage?key=GoSxhkyxXUqY6LXznLBJcmwqkyLA0AnE&center=$lng,$lat&zoom=14&height=160";
    }
    throw "Error: No location provided!";
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionStatus;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$lat,$lng.json?key=GoSxhkyxXUqY6LXznLBJcmwqkyLA0AnE');
    final response = await http.get(url);
    final resData = json.decode(utf8.decode(response.bodyBytes));
    final String resAddress =
        resData['addresses'][0]['address']['freeformAddress'];

    setState(() {
      _isGettingLocation = false;
    });

    if (widget.locationCallback != null) {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: resAddress);
      widget.locationCallback!(
        _pickedLocation!,
      );
    }
  }

  void _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$latitude,$longitude.json?key=GoSxhkyxXUqY6LXznLBJcmwqkyLA0AnE');
    final response = await http.get(url);
    final resData = json.decode(utf8.decode(response.bodyBytes));
    final String resAddress =
        resData['addresses'][0]['address']['freeformAddress'];

    setState(() {
      _isGettingLocation = false;
    });

    if (widget.locationCallback != null) {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: resAddress);
      widget.locationCallback!(
        _pickedLocation!,
      );
    }
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    } else {
      _savePlace(pickedLocation.latitude, pickedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 160.0,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: previewContent,
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        OverflowBar(
          overflowAlignment: OverflowBarAlignment.center,
          alignment: MainAxisAlignment.spaceEvenly,
          overflowSpacing: 12.0,
          children: [
            TextButton.icon(
              label: const Text('Get current location'),
              icon: const Icon(Icons.location_on),
              onPressed: () => _getCurrentLocation(),
            ),
            TextButton.icon(
              label: const Text('Choose location'),
              icon: const Icon(Icons.map_rounded),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
