import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyzapModel {
  final DocumentReference documentReference;

  MyzapModel({this.documentReference});

  Map<String, dynamic> toMap();
}