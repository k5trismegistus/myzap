import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyzapPersonalPlace {
  final String id;
  final String name;
  final LatLng location;

  MyzapPersonalPlace({
    this.id,
    this.name,
    this.location
  });
}