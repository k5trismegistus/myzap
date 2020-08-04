import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/models/myzap_model.dart';

class MyzapSituation extends MyzapModel {
  final String label;
  int referenceCount;

  MyzapSituation(
      {this.label, this.referenceCount, DocumentReference documentReference})
      : super(documentReference: documentReference);

  Map<String, dynamic> toMap() {
    return {
      'label': this.label,
      'referenceCount': this.referenceCount,
    };
  }

  static MyzapSituation fromMap(data, ref) {
    return new MyzapSituation(
      label: data['label'],
      referenceCount: data['referenceCount'],
      documentReference: ref,
    );
  }

  static MyzapSituation initialize({String label, int referenceCount}) {
    return new MyzapSituation(label: label, referenceCount: referenceCount);
  }
}
