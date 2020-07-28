import 'package:flutter/material.dart';
import 'package:myzap/layouts/loadableLayout.dart';
import 'package:myzap/models/myzap_personal_place.dart';
import 'package:myzap/utils/userStore.dart';

class PersonalPlacesPage extends StatefulWidget {

  @override
  _PersonalPlacesPageState createState() => _PersonalPlacesPageState();
}

class _PersonalPlacesPageState extends LoadablePage<PersonalPlacesPage> {
  final title = 'Personal Places';

  List<MyzapPersonalPlace> _personalPlaces = [];

  void initState() {
    super.initState();
    this.setLoading();
    this.fetchPersonalPlaces();
  }

  Future<void> fetchPersonalPlaces() async {
    var currentUser = UserStore().getUser();

    var places = await currentUser.getPersonalPlaces();

    this.setState(() {
      this._personalPlaces = places;
    });

    this.unsetLoading();
  }

  List<Widget> buildPlacesList() {
    return this._personalPlaces.map((p) {
      return ListTile(
        title: Text(p.name),
        onTap: () {
          Navigator.pushNamed(context, '/personalPlace', arguments: p);
        },
      );
    }).toList();
  }

  Widget buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/addPersonalPlace'),
      tooltip: 'Add new personal place',
      child: Icon(Icons.add),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: this.buildPlacesList()
      )
    );
  }
}