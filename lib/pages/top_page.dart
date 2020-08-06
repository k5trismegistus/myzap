import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/models/myzap_situation.dart';
import 'package:myzap/services/search_tasks.dart';
import 'package:myzap/models/myzap_task.dart';
import 'package:myzap/constants/durations.dart';
import 'package:myzap/utils/userStore.dart';
import 'package:myzap/widgets/duration_choice.dart';

class SelectableSituation {
  MyzapSituation instance;
  bool selected = false;

  SelectableSituation(this.instance);
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
    List<SelectableSituation> rst = this.fetchSituationSuggests();

    if (this.mounted) {
      setState(() => this._choices = rst);
    }
  }

  List<SelectableSituation> fetchSituationSuggests() {
    var currentUser = UserStore().getUser();
    // TODO: reloading
    var rst = currentUser.situations.map((sit) {
      // TODO: Filter only situations whose reference count > 0
      return new SelectableSituation(sit);
    }).toList();
    return rst;
  }

  Future<MyzapTask> queryTask() async {
    var currentUser = UserStore().getUser();

    var selectedSituations =
        this._choices.where((c) => c.selected).map((c) => c.instance).toList();

    var selectedTasks =
        await (new SearchTasksService(currentUser, selectedSituations, ''))
            .call();
    var selectedTask = (selectedTasks..shuffle()).first;

    return selectedTask;
  }

  List<Widget> situationChips() {
    return this._choices.map((choice) {
      return InputChip(
          label: Text(choice.instance.label),
          labelStyle: TextStyle(
              color: choice.selected ? Colors.black : Colors.grey,
              fontSize: 16),
          onPressed: () {
            setState(() => choice.selected = !choice.selected);
          });
    }).toList();
  }

  void showAction(Duration duration) async {
    var task = await this.queryTask();
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var currentLocation = LatLng(
      position.latitude,
      position.longitude,
    );

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
              onPressed: () async {
                await task.makeDecision('decline', currentLocation);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () async {
                await task.makeDecision('accept', currentLocation);
                Navigator.pop(context);
              },
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
                            children: this.situationChips()))
                  ]),
              FlatButton(
                onPressed: this._loadChoices,
                color: Colors.blue,
                child: Text(
                  'Reload',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              DurationChoice(selectable: false, onSelected: this.showAction),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addTask'),
        tooltip: 'Add new Task!',
        child: Icon(Icons.add),
      ), //
    );
  }
}
