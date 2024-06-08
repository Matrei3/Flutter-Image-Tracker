import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double latitude, longitude;
  final String address;

  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
}

class Place {
  final String id, title;
  final File image;
  final PlaceLocation placeLocation;

  Place({required this.title, required this.image, required this.placeLocation,String? id})
      : id = id ?? uuid.v4();
}
