import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import "package:google_maps_webservice/places.dart";
import 'package:myzap/models/myzap_personal_place.dart';

class PersonalPlacePage extends StatelessWidget {
  MyzapPersonalPlace _place;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: DotEnv().env['GOOGLE_MAPS_API_KEY']);
  GoogleMapController _googleMapController;

  Set<Marker> _markers = {};

  void _onPressRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Are you sure?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Remove"),
              color: Colors.red,
              onPressed: () async {
                await Firestore.instance
                  .collection("personalPlaces")
                  .document(this._place.id)
                  .delete();
                Navigator.pushReplacementNamed(context, '/personalPlaces');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    this._place = ModalRoute.of(context).settings.arguments;

    this._markers = {Marker(
      markerId: MarkerId(this._place.name),
      position: this._place.location,
      infoWindow: InfoWindow(
        title: this._place.name,
      ),
    )};

    return DefaultLayout(
      title: 'Add new personal place',
      page: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(this._place.name),
              padding: EdgeInsets.all(16),
            ),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  this._googleMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: this._place.location,
                  zoom: 17.0,
                ),
                markers: this._markers,
              ),
            ),
            FlatButton(
              child: Text('Remove this place'),
              onPressed: () { this._onPressRemove(context); },
            )
          ]
        )
      )
    );
  }
}