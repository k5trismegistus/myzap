import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/models/myzap_model.dart';

class MyzapSituation extends MyzapModel{
  final String label;

  MyzapSituation({
    this.label,
    DocumentReference documentReference
  }) : super(documentReference: documentReference);

  Map<String, dynamic> toMap() {
    return {
      'label': this.label,
    };
  }

  static MyzapSituation fromMap(data, ref) {
    return new MyzapSituation(
      label: data['label'],
      documentReference: ref,
    );
  }

  static MyzapSituation initialize({String id, String label}) {
    return new MyzapSituation(label: label);
  }

  Future<bool> save(DocumentReference docRef) async {
    await docRef.setData(this.toMap());
    return true;
  }
}