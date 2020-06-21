import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_task.dart';
import 'myzap_model.dart';

class MyzapUser {
  final String id;
  final List<MyzapTask> tasks;
  final List<MyzapSituation> situations;

  MyzapUser({
    this.id,
    this.tasks,
    this.situations,
  });
}