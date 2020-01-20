import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import "package:google_maps_webservice/places.dart";
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddPersonalPlacePage extends StatefulWidget {
  @override
  _AddPersonalPlacePageState createState() => _AddPersonalPlacePageState();
}

class _AddPersonalPlacePageState extends State<AddPersonalPlacePage> {

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: DotEnv().env['GOOGLE_MAPS_API_KEY']);
  LatLng _location = LatLng(35.681236,139.767125);

  GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Add new personal place',
      page: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: TextEditingController(),
              ),
              suggestionsCallback: (pattern) async {
                var resp = await this._places.searchByText(pattern);
                return resp.results.map((rst) {
                  return rst;
                }).toList();
              },
              itemBuilder: (context, PlacesSearchResult suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              onSuggestionSelected: (PlacesSearchResult suggestion) {
                var loc = LatLng(suggestion.geometry.location.lat, suggestion.geometry.location.lng);
                this.setState(() {
                  this._location = loc;
                  this._googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: loc, zoom: 17.0)
                  ));
                });
              }
            ),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  this._googleMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: this._location,
                  zoom: 17.0,
                ),
                myLocationEnabled: true,
              ),
            )
          ]
        )
      )
    );
  }
}