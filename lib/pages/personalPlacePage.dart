import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';
import "package:google_maps_webservice/places.dart";

class PersonalPlacePageArgument {
  final String title;
  final LatLng latLng;

  PersonalPlacePageArgument(this.title, this.latLng);
}

class PersonalPlacePage extends StatelessWidget {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: DotEnv().env['GOOGLE_MAPS_API_KEY']);

  GoogleMapController _googleMapController;

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {

    final PersonalPlacePageArgument args = ModalRoute.of(context).settings.arguments;

    this._markers = {Marker(
      markerId: MarkerId(args.title),
      position: args.latLng,
      infoWindow: InfoWindow(
        title: args.title,
      ),
    )};

    return DefaultLayout(
      title: 'Add new personal place',
      page: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(args.title),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  this._googleMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: args.latLng,
                  zoom: 17.0,
                ),
                myLocationEnabled: true,
                markers: this._markers,
              ),
            )
          ]
        )
      )
    );
  }
}