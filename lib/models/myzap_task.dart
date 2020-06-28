import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_model.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_user.dart';
import 'myzap_decision.dart';

class MyzapTaskParams {
  final String description;
  final int duration;
  final LatLng location;
  final List<MyzapSituation> situations;

  MyzapTaskParams({
    this.description,
    this.duration,
    this.location,
    this.situations,
  });
}

class MyzapTask extends MyzapModel {
  final String id;
  final String description;
  final int duration;
  final DateTime createdAt;
  final LatLng location;
  final MyzapDecision completion;
  final List<MyzapDecision> declinations;
  final List<MyzapSituation> situations;

  MyzapTask({
    this.id,
    this.description,
    this.situations,
    this.duration,
    this.createdAt,
    this.location,
    this.completion,
    this.declinations,
    DocumentReference documentReference
  }) : super(documentReference: documentReference);

  static Future<MyzapTask> create(MyzapUser user, MyzapTaskParams params) async {
    var createdAt = DateTime.now();

    // TODO: Create record in user record

    await user.documentReference.updateData({
      'tasks': FieldValue.arrayUnion([{
        'description': params.description,
        'situations': params.situations.map((s) => s.toMap()).toList(),
        'createdAt': createdAt,
        'duraion': params.duration,
        'location': {
          'latitude': params.location.latitude,
          'longitude': params.location.longitude,
        },
        'completion': null,
        'declination': [],
      }])
    });

    // TODO: build instance from firebase record
    return new MyzapTask();
  }


  // TODO: Implement this
  Map<String, dynamic> toMap() {
    return {};
  }

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

    if (type == 'decline') {
      await Firestore.instance
        .collection("tasks")
        .document(this.id)
        .updateData({
          'declination': [...(this.declinations != null ? this.declinations : []).map((d) => d.toMap()), decision.toMap()],
        });
      return true;
    }
  }
}