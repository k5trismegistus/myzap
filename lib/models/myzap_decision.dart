import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'myzap_model.dart';

class MyzapDecision implements MyzapModel {
  final DateTime madeAt;
  final LatLng madeLocation;
  // Dart does not have union type.
  // final String type = 'accept' | 'decline';
  final String type;

  MyzapDecision({
    this.madeAt,
    this.madeLocation,
    this.type,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'madeAt': this.madeAt,
      'madeLocation': {
        'latitude': this.madeLocation.latitude,
        'longitude': this.madeLocation.longitude,
      },
      'type': this.type,
    };
  }
}