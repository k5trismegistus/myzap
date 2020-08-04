import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_personal_place.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_task.dart';
import 'myzap_decision.dart';
import 'myzap_model.dart';

class MyzapUser extends MyzapModel {
  final String id;
  final List<MyzapTask> tasks;
  final List<MyzapSituation> situations;
  final FirebaseUser firebaseUser;

  MyzapUser(
      {this.id,
      this.tasks,
      this.situations,
      this.firebaseUser,
      DocumentReference documentReference})
      : super(documentReference: documentReference);

  String uid() {
    return this.firebaseUser.uid;
  }

  String photoUrl() {
    return this.firebaseUser.photoUrl;
  }

  String displayName() {
    return this.firebaseUser.displayName;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'displayName': this.displayName(),
    };
  }

  static Future<MyzapUser> initOrCreate(FirebaseUser firebaseUser) async {
    var uid = firebaseUser.uid;
    var query =
        Firestore.instance.collection("users").where('uid', isEqualTo: uid);
    var records = (await query.getDocuments()).documents;

    var recordLength = records.length;

    // If user record didn't exist on firestore
    if (recordLength == 0) {
      var documentReference = Firestore.instance.collection("users").document();

      await documentReference.setData({
        'uid': uid,
      });

      var myzapUser = new MyzapUser(
        id: uid,
        firebaseUser: firebaseUser,
        documentReference: documentReference,
      );
      return myzapUser;
    }

    var documentReference = records.first.reference;

    var tasksRecords =
        await documentReference.collection('tasks').getDocuments();
    var tasks = tasksRecords.documents.map((taskRecord) {
      return MyzapTask.fromMap(taskRecord.data, taskRecord.reference);
    }).toList();

    var situationsRecords =
        await documentReference.collection('situations').getDocuments();
    var situations = situationsRecords.documents.map((situationRecord) {
      return MyzapSituation.fromMap(
          situationRecord.data, situationRecord.reference);
    }).toList();

    return new MyzapUser(
      id: uid,
      tasks: tasks,
      situations: situations,
      firebaseUser: firebaseUser,
      documentReference: documentReference,
    );
  }

  Future<MyzapTask> addTask({
    String description,
    int duration,
    LatLng location,
    List<MyzapSituation> situations,
    List<MyzapDecision> declination,
    MyzapDecision completion,
  }) async {
    var task = MyzapTask.initialize(
      description: description,
      duration: duration,
      location: location,
      situations: situations,
      declination: declination,
      completion: completion,
    );
    var newTaskDocRef = this.documentReference.collection('tasks').document();

    await task.save(newTaskDocRef);
    return task;
  }

  Future<MyzapSituation> addSituation({
    String label,
  }) async {
    var situation = MyzapSituation.initialize(label: label, referenceCount: 0);
    var newSituationDocRef =
        this.documentReference.collection('situations').document();

    await situation.save(newSituationDocRef);
    return situation;
  }

  Future<MyzapPersonalPlace> addPersonalPlace({
    String name,
    LatLng location,
  }) async {
    var personalPlace = MyzapPersonalPlace.initialize(
      name: name,
      location: location,
    );
    var newPersonalPlaceDocRef =
        this.documentReference.collection('personal_places').document();

    await personalPlace.save(newPersonalPlaceDocRef);
    return personalPlace;
  }

  Future<List<MyzapPersonalPlace>> getPersonalPlaces() async {
    var data = await Firestore.instance
        .collection('users')
        .document(this.documentReference.documentID)
        .collection('personal_places')
        .getDocuments();

    List<MyzapPersonalPlace> results = data.documents.map((document) {
      return MyzapPersonalPlace.fromMap(document.data, document.reference);
    }).toList();

    return results;
  }
}
