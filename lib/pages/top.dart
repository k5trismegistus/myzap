import 'package:flutter/material.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myzap/utils/algolia.dart';
import 'package:myzap/models/myzap_task.dart';
import 'package:myzap/constants/durations.dart';
import 'package:myzap/widgets/duration_choice.dart';

class SelectableSituation {
  String objectId;
  String label;
  bool selected = false;

  SelectableSituation(this.objectId, this.label);
}

class TopPage extends StatefulWidget {
  TopPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  List<SelectableSituation> _choices = [];

  @override
  void initState() {
    super.initState();
    this._loadChoices();
  }

  void _loadChoices() async {

    List<SelectableSituation> rst = await this.fetchSituationSuggests();

    if (this.mounted) {
      setState(() => this._choices = rst);
    }
  }

  Future<List<SelectableSituation>> fetchSituationSuggests() async {
    var snapshot = await Firestore.instance.collection('situations').limit(10).getDocuments();
    var rst = snapshot.documents.map((doc) {
      return new SelectableSituation(
        doc.documentID,
        doc['label'],
      );
    }).toList();
    return rst;
  }

  Future<MyzapTask> queryTask() async {
      var selectedSituationIds = this._choices.where((c) => c.selected).map((c) => c.objectId);
      var _snap = await AlgoliaStore.getInstance().index('tasks').search(selectedSituationIds.join(', ')).getObjects();

      if (_snap.hits.length == 0) {
        return null;
      }

      var selected = (_snap.hits..shuffle()).first;
      return new MyzapTask(selected.objectID, selected.data['description'], []);
    }

    List<Widget> situationChips() {
      return this._choices.map((choice) {
        return InputChip(
          label: Text(choice.label),
          labelStyle: TextStyle(color: choice.selected ? Colors.black : Colors.grey, fontSize: 16),
          onPressed: () {
            setState(()  => choice.selected = !choice.selected);
          }
        );
      }).toList();
    }

    void showAction(Duration duration) async {
      var task = await this.queryTask();

      if (task == null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Guru has no answer..."),
              content: Text(''),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        return;
      }

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Guru's oracle..."),
            content: Text(task.description),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return DefaultLayout(
        title: widget.title,
        page: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 0.0,
                      direction: Axis.horizontal,
                      children: this.situationChips()
                    )
                  )
                ]
              ),
              FlatButton(
                onPressed: this._loadChoices,
                color: Colors.blue,
                child: Text(
                  'Reload',
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: 20.0
                  ),
                ),
              ),
              DurationChoice(
                selectable: false,
                onSelected: this.showAction
              ),
            ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/addTask'),
          tooltip: 'Add new Task!',
          child: Icon(Icons.add),
        ), //
      );
    }
  }
