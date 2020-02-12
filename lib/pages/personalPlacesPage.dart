import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:myzap/models/myzap_personal_place.dart';
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
  List<MyzapPersonalPlace> _personalPlaces = [];


  void initState() {
    super.initState();
    this.fetchPersonalPlaces();
  }

  Future<void> fetchPersonalPlaces() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var userId = currentUser.uid;

    var snapshot = Firestore.instance.collection('personalPlaces').where('userRef', isEqualTo: '/users/$userId').snapshots();
    List<MyzapPersonalPlace> _fetched = this._personalPlaces;
    snapshot.listen((data) {
      data.documents.forEach((doc) {
        var d = doc.data;
        _fetched.add(MyzapPersonalPlace(
          doc.documentID,
          d['name'],
          LatLng(
            d['location']['lat'],
            d['location']['lng'],
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