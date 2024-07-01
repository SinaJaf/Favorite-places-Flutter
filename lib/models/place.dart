import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double? latitude;
  final double? longitude;
  final String? address;
}

class Place {
  Place({
    String? id,
    required this.name,
    this.image,
    this.imageWeb,
    this.location,
  }) : id = id ?? uuid.v4();
  String name;
  File? image;
  Uint8List? imageWeb;
  PlaceLocation? location;
  final String id;
}

class PlaceProvider extends StateNotifier<Place> {
  PlaceProvider() : super(Place(name: '', image: File('')));

  void updatePlaceInfo(String name) {
    state.name = name;
  }
}
