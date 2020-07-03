import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/models/myzap_model.dart';

class MyzapSituation extends MyzapModel{
  final String id;
  final String label;

  MyzapSituation({
    this.id,
    this.label,
    DocumentReference documentReference
  }) : super(documentReference: documentReference);

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'label': this.label,
    };
  }

  static MyzapSituation fromMap(data, ref) {
    return new MyzapSituation(
      id: data['id'],
      label: data['label'],
      documentReference: ref,
    );
  }
}