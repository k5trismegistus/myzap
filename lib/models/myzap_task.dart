import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_model.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_user.dart';
import 'myzap_decision.dart';
import 'myzap_decision.dart';

class MyzapTaskParams {
  final String description;
  final int duration;
  final LatLng location;
  final List<MyzapSituation> situations;
  final List<MyzapDecision> declination;
  final MyzapDecision completion;

  MyzapTaskParams({
    this.description,
    this.duration,
    this.location,
    this.situations,
    this.declination,
    this.completion
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

    var task = new MyzapTask(
      description: params.description,
        situations: params.situations,
        createdAt: createdAt,
        duration: params.duration,
        location: new LatLng(params.location.latitude, params.location.longitude),
        completion: null,
        declinations: [],
    );
    await user.addTask(task);

    return task;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'situations': this.situations.map((s) => s.toMap()).toList(),
      'createdAt': createdAt,
      'duraion': this.duration,
      'location': {
        'latitude': this.location.latitude,
        'longitude': this.location.longitude,
      },
      'completion': this.completion?.toMap(),
      'declination': this.declinations.map((d) => d.toMap()).toList(),
    };
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