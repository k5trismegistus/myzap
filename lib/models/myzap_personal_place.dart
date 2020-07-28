import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/models/myzap_model.dart';

class MyzapPersonalPlace extends MyzapModel {
  final String name;
  final LatLng location;

  MyzapPersonalPlace({
    this.name,
    this.location,
    DocumentReference documentReference
  }) : super(documentReference: documentReference);

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'location': {
        'latitude': this.location.latitude,
        'longitude': this.location.longitude,
      }
    };
  }
  static MyzapPersonalPlace fromMap(data, ref) {
    return new MyzapPersonalPlace(
      name: data['name'],
      location: LatLng(
        data['latitude'],
        data['longitude'],
      ),
      documentReference: ref,
    );
  }

  static MyzapPersonalPlace initialize({String name, LatLng location}) {
    return new MyzapPersonalPlace(name: name, location: location);
  }
}