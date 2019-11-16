import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchedSituation {
  int id;
  String label;

  FetchedSituation(this.id, this.label);
}

List<String> situations = [
  'Before go to bed, 30 minutes',
  'During commuting',
  'Friday night',
];


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

  // In real implementation, fetch from DB or API
  Future<List<FetchedSituation>> fetchSituations(String inputedText) {
    List<FetchedSituation> rst = [];
    situations.asMap().forEach((idx, label) {
      rst.add(new FetchedSituation(idx, label));
    });

    return new Future.delayed(new Duration(milliseconds: 50), (){
      return rst;
    });
  }

  List<Widget> situationChips() {
    return this._selectedSituations.map((sit) {
      return InputChip(
        label: Text(sit.label),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
      );
    }).toList();
  }

  void handleAddTask() {
    Firestore.instance.collection('testData').document()
    .setData({
      'description': this._desriptionInputController.text,
      'situations': this._selectedSituations.map((s) => s.label).toList()
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Add new task',
      page: Container(
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
                return ListTile(
                  title: Text(suggestion.label),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  this._situationInputController.text = '';
                  this._selectedSituations.add(suggestion);
                });
              }
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
            FlatButton(
              child: Text('Add'),
              onPressed: this.handleAddTask,
            )
          ]
        )
      )
    );
  }
}