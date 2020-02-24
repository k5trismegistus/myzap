import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'myzap_decision.dart';

class MyzapTask {
  final String id;
  final String description;
  final int duration;
  final DateTime createdAt;
  final LatLng location;
  final MyzapDecision completion;
  final List<MyzapDecision> declinations;
  final List<MyzapSituation> situations;
  final String userRef;

  MyzapTask({
    this.id,
    this.description,
    this.situations,
    this.duration,
    this.createdAt,
    this.location,
    this.completion,
    this.declinations,
    this.userRef,
  });

  Future<bool> makeDecision(String type, LatLng decidedLocation) async {
    var currentTime = DateTime.now();

    var decision = MyzapDecision(
      madeAt: currentTime,
      madeLocation: decidedLocation,
      type: type
    );

    if (type == 'accept') {
      await Firestore.instance
        .collection("tasks")
        .document(this.id)
        .updateData({
          'completion': decision.toMap(),
        });
      return true;
    }
  }
}