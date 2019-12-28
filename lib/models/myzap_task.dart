import 'package:myzap/models/myzap_situation.dart';

class MyzapTask {
  final String id;
  final String description;
  final List<MyzapSituation> situations;

  MyzapTask(this.id, this.description, this.situations);
}