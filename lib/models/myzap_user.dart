import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_task.dart';
import 'myzap_model.dart';

class MyzapUser extends MyzapModel {
  final String id;
  final List<MyzapTask> tasks;
  final List<MyzapSituation> situations;
  final FirebaseUser firebaseUser;

  MyzapUser({
    this.id,
    this.tasks,
    this.situations,
    this.firebaseUser,
  });

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
    var record = await Firestore.instance.collection("users")
      .where('uid', isEqualTo: uid)
      .getDocuments();

    var recordLength = record.documents.length;

    // If user record didn't exist on firestore
    if (recordLength == 0) {
      Firestore.instance.collection("users")
        .document()
        .setData({
          'uid': uid,
          'tasks': [],
          'situations': [],
        });

      return new MyzapUser(
        id: uid,
        tasks: [],
        situations: [],
        firebaseUser: firebaseUser,
      );
    }
    print('already exist');

    // TODO: Build tasks and situations from firestore record
    return new MyzapUser(id: uid, tasks: [], situations: [], firebaseUser: firebaseUser);
  }
}