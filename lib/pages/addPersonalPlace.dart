import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:google_maps_webservice/places.dart";
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddPersonalPlacePage extends StatefulWidget {
  @override
  _AddPersonalPlacePageState createState() => _AddPersonalPlacePageState();
}

class _AddPersonalPlacePageState extends State<AddPersonalPlacePage> {

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: DotEnv().env['GOOGLE_MAPS_API_KEY']);

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
                  return rst.name;
                }).toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) { }
            ),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {},
                initialCameraPosition: CameraPosition(
                  target: LatLng(35.681236,139.767125),
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