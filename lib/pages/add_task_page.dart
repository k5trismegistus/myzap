import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/models/myzap_task.dart';
import 'package:myzap/utils/algolia.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myzap/utils/userStore.dart';
import 'package:myzap/widgets/duration_choice.dart';
import 'package:myzap/widgets/waiting.dart';
import 'package:myzap/constants/durations.dart';

class FetchedSituation {
  MyzapSituation instance;
  bool nullPlaceholder; // if this value is true, this instance represent special value.

  FetchedSituation(this.instance, this.nullPlaceholder);
  factory FetchedSituation.build({String id, String label, bool nullPlaceholder}) {
    var instance = new MyzapSituation(id: id, label: label);
    return FetchedSituation(instance, nullPlaceholder);
  }
}

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}


class _AddTaskPageState extends State<AddTaskPage> {

  final TextEditingController _desriptionInputController = TextEditingController();
  final TextEditingController _situationInputController = TextEditingController();

  List<FetchedSituation> _selectedSituations = [];
  Duration _selectedDuration = durations.first;
  bool _loading = false;

  Future<List<FetchedSituation>> fetchSituations(String inputedText) async {
    var _snap = await AlgoliaStore.getInstance().index('situations')
                                .search(inputedText)
                                .getObjects();
    var lst = _snap.hits.map((h) {
      return new FetchedSituation.build(id: h.objectID, label: h.data['label'], nullPlaceholder: false);
    }).toList();
    lst.add(new FetchedSituation.build(id: '', label: '', nullPlaceholder: true));
    return lst;
  }

  List<Widget> situationChips() {
    return this._selectedSituations.map((sit) {
      return InputChip(
        label: Text(sit.instance.label),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
        onDeleted: () {
          setState(() {
            this._selectedSituations.remove(sit);
          });
        },
      );
    }).toList();
  }

  Future<String> handleAddSituation(suggestion) async {
    var newSituationRef = Firestore.instance.collection('situations').document();

    await newSituationRef.setData({
      'label': suggestion
    });

    var sit = new FetchedSituation.build(id: newSituationRef.documentID, label: suggestion, nullPlaceholder: false);
    this.handleSelectSituation(sit);

    return newSituationRef.documentID;
  }

  void handleSelectSituation(suggestion) {
    if (suggestion.nullPlaceholder) {
      this.handleAddSituation(suggestion.instance.label);
      return;
    }

    setState(() {
      this._situationInputController.text = '';
      this._selectedSituations.add(suggestion);
    });
  }

  Future<void> handleAddTask() async {
    this.setState(() {
      this._loading = true;
    });

    var currentUser = UserStore().getUser();

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var params = MyzapTaskParams(
      description: this._desriptionInputController.text,
      duration: this._selectedDuration.durationSeconds,
      location: LatLng(
        position.latitude,
        position.longitude,
      ),
      situations: this._selectedSituations.map((s) => s.instance).toList(),
    );

    await currentUser.addTask(params);

    Navigator.pushReplacementNamed(context, '/top');
  }

  @override
  Widget build(BuildContext context) {
    Geolocator().checkGeolocationPermissionStatus();

    var body = Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _desriptionInputController,
              decoration: InputDecoration(hintText: 'Task description'),
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._situationInputController,
              ),
              suggestionsCallback: (pattern) async {
                return await fetchSituations(pattern);
              },
              itemBuilder: (context, suggestion) {
                if (suggestion.nullPlaceholder) {
                  return ListTile(
                    title: Text("Add new situation \"${this._situationInputController.text}\"")
                  );
                }
                return ListTile(
                  title: Text(suggestion.instance.label),
                );
              },
              onSuggestionSelected: this.handleSelectSituation
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.0,
                runSpacing: 0.0,
                direction: Axis.horizontal,
                children: this.situationChips()
              )
            ),
            DurationChoice(
              selectable: true,
              selected: this._selectedDuration,
              onSelected: (duration) {
                this.setState(() {
                  this._selectedDuration = duration;
                });
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: this.handleAddTask,
            )
          ]
        )
      );

    return DefaultLayout(
      title: 'Add new task',
      page: this._loading ? WaitingWidget(bgPage: body) : body
    );
  }
}