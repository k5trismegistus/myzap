import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyzapModel {
  DocumentReference documentReference;

  MyzapModel({this.documentReference});

  Map<String, dynamic> toMap();
  // Map<String, dynamic> toFireStoreMap();

  // MyzapModel fromMap();

    Future<bool> save(DocumentReference docRef) async {
    if (this.documentReference != null) {
      await this.documentReference.updateData(this.toMap());
      return true;
    }

    if (docRef != null) {
      this.documentReference = docRef;
      await this.documentReference.setData(this.toMap());
      return true;
    }

    // TODO: handle error
    return false;
  }
}