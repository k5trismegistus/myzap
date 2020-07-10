import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyzapModel {
  DocumentReference documentReference;

  MyzapModel({this.documentReference});

  Map<String, dynamic> toMap();
  // Map<String, dynamic> toFireStoreMap();

  // MyzapModel fromMap();
}