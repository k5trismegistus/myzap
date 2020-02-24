import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/utils/algolia.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myzap/widgets/duration_choice.dart';
import 'package:myzap/widgets/waiting.dart';
import 'package:myzap/constants/durations.dart';

class FetchedSituation {
  String id;
  String label;
  bool nullPlaceholder; // if this value is true, this instance represent special value.

  FetchedSituation(this.id, this.label, this.nullPlaceholder);
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
  Duration _selectedDuration = Durations.first;
  bool _loading = false;

  Future<List<FetchedSituation>> fetchSituations(String inputedText) async {
    var _snap = await AlgoliaStore.getInstance().index('situations')
                                .search(inputedText)
                                .getObjects();
    var lst = _snap.hits.map((h) {
      return new FetchedSituation(h.objectID, h.data['label'], false);
    }).toList();
    lst.add(new FetchedSituation('', inputedText, true));
    return lst;
  }

  List<Widget> situationChips() {
    return this._selectedSituations.map((sit) {
      return InputChip(
        label: Text(sit.label),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
        onDeleted: () {
          setState(() {
            this._selectedSituations.remove(sit);
          });
        },
      );
    }).toList();
  }

  String handleAddSituation(suggestion) {
    var newSituationRef = Firestore.instance.collection('situations').document();

    newSituationRef.setData({
      'label': suggestion
    });

    var sit = new FetchedSituation(newSituationRef.documentID, suggestion, false);
    this.handleSelectSituation(sit);

    return newSituationRef.documentID;
  }

  void handleSelectSituation(suggestion) {
    if (suggestion.nullPlaceholder) {
      this.handleAddSituation(suggestion.label);
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

    var currentUser = await FirebaseAuth.instance.currentUser();
    var userId = currentUser.uid;

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Firestore.instance.collection('tasks').document()
      .setData({
        'description': this._desriptionInputController.text,
        'situationIds': this._selectedSituations.map((s) => '/situations/${s.id}').toList(),
        'createdAt': DateTime.now(),
        'duraion': this._selectedDuration.durationSeconds,
        'location': {
          'lat': position.latitude,
          'long': position.longitude,
        },
        'completedAt': null,
        'declination': [],
        'userRef': '/users/$userId',
      });
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
                    title: Text("Add new situation \"${suggestion.label}\"")
                  );
                }
                return ListTile(
                  title: Text(suggestion.label),
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