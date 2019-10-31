import 'package:flutter/material.dart';

// Below: for mock implementation

class SelectableSituation {
  int index;
  String label;
  bool selected = false;

  SelectableSituation(this.index, this.label);
}

List<String> situations = [
  'Before go to bed, 30 minutes',
  'During commuting',
  'Friday night',
];

// Above: for mock implementation

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

  void _loadChoices() {
    List<SelectableSituation> rst = [];
    situations.asMap().forEach((index, situation) {
      rst.add(new SelectableSituation(index, situation));
    });

    setState(() => this._choices = rst);
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

  void showAction() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Guru's oracle..."),
          content: Text("Go to bed now"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
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
              onPressed: this.showAction,
              color: Colors.blue,
              child: Text(
                'Tell me what to do',
                style: TextStyle(
                  color:Colors.white,
                  fontSize: 20.0
                ),
              ),
            )
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addTask'),
        tooltip: 'Add new Task!',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
