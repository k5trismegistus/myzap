import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'myzap_decision.dart';

class MyzapTask {
  final String id;
  final String description;
  final int duration;
  final DateTime createdAt;
  final LatLng location;
  final MyzapDecision completedAt;
  final List<MyzapDecision> declinations;
  final List<MyzapSituation> situations;

  MyzapTask({
    this.id,
    this.description,
    this.situations,
    this.duration,
    this.createdAt,
    this.location,
    this.completedAt,
    this.declinations
  });
}