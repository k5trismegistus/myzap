import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchedSiuation {
  int id;
  String label;

  FetchedSiuation(this.id, this.label);
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

  List<FetchedSiuation> _selectedSituations = [];

  // In real implementation, fetch from DB or API
  Future<List<FetchedSiuation>> fetchSituations(String inputedText) {
    List<FetchedSiuation> rst = [];
    situations.asMap().forEach((idx, label) {
      rst.add(new FetchedSiuation(idx, label));
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
    .setData({ 'title': 'test' });
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
              decoration: InputDecoration(hintText: 'Task description'),
            ),
            TypeAheadField(
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