import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyzapModel {
  DocumentReference documentReference;

  MyzapModel({this.documentReference});

  Map<String, dynamic> toMap();
  // Map<String, dynamic> toFireStoreMap();

  // MyzapModel fromMap();

  Future<bool> save(DocumentReference docRef) async {
    if (this.documentReference != null) {
      await this.documentReference.updateData(this.toFireStoreMap());
      return true;
    }

    if (docRef != null) {
      this.documentReference = docRef;
      await this.documentReference.setData(this.toFireStoreMap());
      return true;
    }

    // TODO: handle error
    return false;
  }

  Map<String, dynamic> toFireStoreMap() {
    return this.toMap();
  }
}
