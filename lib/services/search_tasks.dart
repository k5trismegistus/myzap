import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_task.dart';
import 'package:myzap/models/myzap_user.dart';
import 'package:myzap/utils/algolia.dart';

class SearchTasksService {
  final MyzapUser user;
  final List<MyzapSituation> selectedSituations;
  final String searchKeyword;

  SearchTasksService(this.user, this.selectedSituations, this.searchKeyword);

  Future<List<MyzapTask>> call() async {
    var userFilter = 'userId:${this.user.documentReference.documentID}';
    var selectedSituationIdFilter = this.selectedSituations
      .map((c) => c.documentReference.documentID)
      .toList()
      .join(' OR ');

    var _snap = await AlgoliaStore
      .getInstance()
      .index('tasks')
      .setFacetFilter(userFilter)
      .setFacetFilter(selectedSituationIdFilter)
      .search('')
      .getObjects();

    if (_snap.hits.length == 0) {
      return [];
    }

    var documentIDs = _snap.hits.map((d) => d.objectID).toList();

    var snapshot = Firestore.instance.collection('users')
      .document(this.user.documentReference.documentID)
      .collection('tasks')
      .where(FieldPath.documentId, whereIn: documentIDs)
      .snapshots();

    List<MyzapTask> results = [];

    snapshot.listen((data) {
      data.documents.map((document) {
        results.add(MyzapTask.fromMap(document.data, document.reference));
      }).toList();
    });

    return results;
  }
}