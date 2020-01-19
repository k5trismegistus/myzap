import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myzap/layouts/defaultLayout.dart';

class AddPersonalPlacePage extends StatefulWidget {
  @override
  _AddPersonalPlacePageState createState() => _AddPersonalPlacePageState();
}

class _AddPersonalPlacePageState extends State<AddPersonalPlacePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Add new personal place',
      page: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
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