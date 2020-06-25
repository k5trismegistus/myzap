import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/models/myzap_personal_place.dart';
import 'package:myzap/utils/userStore.dart';
import 'package:myzap/widgets/waiting.dart';

class PersonalPlacesPage extends StatefulWidget {

  @override
  _PersonalPlacesPageState createState() => _PersonalPlacesPageState();
}

class _PersonalPlacesPageState extends State<PersonalPlacesPage> {
  bool _loading = true;
  List<MyzapPersonalPlace> _personalPlaces = [];


  void initState() {
    super.initState();
    this.fetchPersonalPlaces();
  }

  Future<void> fetchPersonalPlaces() async {
    var currentUser = UserStore().getUser();
    var userId = currentUser.uid();

    var snapshot = Firestore.instance.collection('personalPlaces').where('userRef', isEqualTo: '/users/$userId').snapshots();
    List<MyzapPersonalPlace> _fetched = this._personalPlaces;
    snapshot.listen((data) {
      data.documents.forEach((doc) {
        var d = doc.data;
        _fetched.add(MyzapPersonalPlace(
          id: doc.documentID,
          name: d['name'],
          location: LatLng(
            d['location']['latitude'],
            d['location']['longitude'],
          )
        ));
      });

      this.setState(() {
        this._loading = false;
        this._personalPlaces = _fetched;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    var body = Container(
      child: ListView(
        children: this.buildPlacesList()
      ),
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