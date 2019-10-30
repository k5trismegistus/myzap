import 'package:flutter/material.dart';


class TopPage extends StatefulWidget {
  TopPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  // Sample
  List<String> _situations = [
    'Before go to bed, 30 minutes',
    'During commuting',
    'Friday night',
  ];

  List<Widget> situationChips() {
    return this._situations.map((situation) {
      return Chip(
        label: Text(situation),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16)
      );
    }).toList();
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
