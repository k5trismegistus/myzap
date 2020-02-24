import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DecisionType {
  Accept,
  Decline
}

class MyzapDecision {
  final DateTime madeAt;
  final LatLng madeLocation;
  final DecisionType type;

  MyzapDecision({
    this.madeAt,
    this.madeLocation,
    this.type,
  });
}