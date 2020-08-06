import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/loadableLayout.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myzap/utils/userStore.dart';
import 'package:myzap/widgets/duration_choice.dart';
import 'package:myzap/constants/durations.dart';

class FetchedSituation {
  MyzapSituation instance;
  bool
      nullPlaceholder; // if this value is true, this instance represent special value.

  FetchedSituation(this.instance, this.nullPlaceholder);
}

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends LoadablePage<AddTaskPage> {
  final title = 'Add new task';

  final TextEditingController _desriptionInputController =
      TextEditingController();
  final TextEditingController _situationInputController =
      TextEditingController();

  List<FetchedSituation> _selectedSituations = [];
  Duration _selectedDuration = durations.first;

  List<FetchedSituation> fetchSituations(String inputedText) {
    var currentUser = UserStore().getUser();

    // TODO: Filter only situation which contain input string
    var lst = currentUser.situations
        .map((sit) => FetchedSituation(sit, false))
        .toList();
    lst.add(new FetchedSituation(null, true));
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

  Future<FetchedSituation> handleAddSituation(String label) async {
    var currentUser = UserStore().getUser();
    var situation = await currentUser.addSituation(label: label);

    var sit = new FetchedSituation(situation, false);
    return sit;
  }

  Future<void> handleSelectSituation(FetchedSituation suggestion) async {
    if (suggestion.nullPlaceholder) {
      var newSit =
          await this.handleAddSituation(this._situationInputController.text);
      setState(() {
        this._situationInputController.text = '';
        this._selectedSituations.add(newSit);
      });
      return;
    }

    setState(() {
      this._situationInputController.text = '';
      this._selectedSituations.add(suggestion);
    });
  }

  Future<void> handleAddTask() async {
    this.setLoading();

    var currentUser = UserStore().getUser();

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    await currentUser.addTask(
      description: this._desriptionInputController.text,
      duration: this._selectedDuration.durationSeconds,
      location: LatLng(
        position.latitude,
        position.longitude,
      ),
      situations: this._selectedSituations.map((s) => s.instance).toList(),
    );

    this.unsetLoading();
    Navigator.pushReplacementNamed(context, '/top');
  }

  Widget buildBody(BuildContext context) {
    Geolocator().checkGeolocationPermissionStatus();

    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          TextField(
            controller: _desriptionInputController,
            decoration: InputDecoration(hintText: 'Task description'),
          ),
          TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._situationInputController,
              ),
              suggestionsCallback: (pattern) async {
                return fetchSituations(pattern);
              },
              itemBuilder: (context, suggestion) {
                if (!suggestion.nullPlaceholder) {
                  return ListTile(
                    title: Text(suggestion.instance.label),
                  );
                }
                return ListTile(
                    title: Text(
                        "Add new situation \"${this._situationInputController.text}\""));
              },
              onSuggestionSelected: this.handleSelectSituation),
          Expanded(
              child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 0.0,
                  direction: Axis.horizontal,
                  children: this.situationChips())),
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
        ]));
  }
}
