import 'package:flutter/material.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/widgets/waiting.dart';

class FetchedPersonalPlaces {
  final String id;
  final String title;

  FetchedPersonalPlaces(this.id, this.title);
}

class PersonalPlacesPage extends StatefulWidget {

  @override
  _PersonalPlacesPageState createState() => _PersonalPlacesPageState();
}

class _PersonalPlacesPageState extends State<PersonalPlacesPage> {
  bool _loading = true;

  // Future<List<FetchedSituation>> fetchPersonal() {

  // }

  @override
  Widget build(BuildContext context) {
    var body = Container(
      child: Column(),
    );

    return DefaultLayout(
      title: 'Personal Places',
      page: this._loading ? WaitingWidget(bgPage: body) : body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addPersonalPlace'),
        tooltip: 'Add new personal place',
        child: Icon(Icons.add),
      ), //
    );
  }
}