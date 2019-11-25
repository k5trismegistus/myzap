import 'package:myzap/models/myzap_situation.dart';

class MyzapTask {
  final String id;
  final String label;
  final List<MyzapSituation> situations;

  MyzapTask(this.id, this.label, this.situations);
}