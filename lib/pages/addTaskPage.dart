import 'package:flutter/material.dart';


class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}


class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new task'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Text('Add task page')
            )
          ]
        )
      )
    );
  }
}