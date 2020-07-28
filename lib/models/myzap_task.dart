import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_model.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'myzap_decision.dart';

class MyzapTask extends MyzapModel {
  final String description;
  final int duration;
  final DateTime createdAt;
  final LatLng location;
  final MyzapDecision completion;
  final List<MyzapDecision> declinations;
  final List<MyzapSituation> situations;

  MyzapTask({
    this.description,
    this.situations,
    this.duration,
    this.createdAt,
    this.location,
    this.completion,
    this.declinations,
    DocumentReference documentReference
  }) : super(documentReference: documentReference);

  static MyzapTask initialize({
    String description,
    int duration,
    LatLng location,
    List<MyzapSituation> situations,
    List<MyzapDecision> declination,
    MyzapDecision completion,
  }) {
    var createdAt = DateTime.now();

    var task = new MyzapTask(
      description: description,
      situations: situations,
      createdAt: createdAt,
      duration: duration,
      location: location,
      completion: null,
      declinations: [],
    );

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

  Map<String, dynamic> toFireStoreMap() {
    return {
      'description': this.description,
      'createdAt': createdAt,
      'duraion': this.duration,
      'location': {
        'latitude': this.location.latitude,
        'longitude': this.location.longitude,
      },
      'completion': this.completion?.toMap(),
      'situationsRef': this.situations.map((situation) => situation.documentReference.documentID).toList()
    };
  }

  factory MyzapTask.fromMap(Map<dynamic, dynamic> data, DocumentReference ref) {
    return new MyzapTask(
      description: data['description'],
      duration: data['duration'],
      location: LatLng(data['location']['latitude'], data['location']['longitude']),
      situations: [],
      declinations: data['declinations'] != null ?
        data['declinations'].map((d) => MyzapDecision.fromMap(Map<String,dynamic>.from(d))).toList() :
        [],
      completion: data['completion'] != null ?
        MyzapDecision.fromMap(Map<String,dynamic>.from(data['completion'])) :
        null,
      documentReference: ref,
    );
  }

  Future<bool> makeDecision(String type, LatLng decidedLocation) async {
    var currentTime = DateTime.now();

    var decision = MyzapDecision(
      madeAt: currentTime,
      madeLocation: decidedLocation,
      type: type
    );

    if (type == 'accept') {
      await this.documentReference
        .updateData({
          'completion': decision.toMap(),
        });
      return true;
    }

    // TODO: Use subcollection
    if (type == 'decline') {
      var declineDocref = this.documentReference
        .collection('declinations')
        .document();

      decision.save(declineDocref);


        // .updateData({
        //   'declination': [...(this.declinations != null ? this.declinations : []).map((d) => d.toMap()), decision.toMap()],
        // });
      return true;
    }

    // TODO: handle error
    return false;
  }
}