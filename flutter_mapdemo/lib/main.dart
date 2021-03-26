import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//https://codelabs.developers.google.com/codelabs/google-maps-in-flutter#0

void main() => runApp(MyApp());

final LatLng CHEYENNE = new LatLng(41.1400, -104.8197);  //Note, West is a negative, East is positive
final LatLng LARAMIE = new LatLng(41.312928, -105.587253);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {
      _markers.clear();
      Marker laramie_marker = Marker(
        markerId: MarkerId("Laramie"),
        position: LARAMIE,
        infoWindow: InfoWindow(
           title: "Laramie",
          snippet: "home of UW"
        )
      );
      _markers["Laramie"] = laramie_marker;
      Marker cheyenne_marker = Marker(
          markerId: MarkerId("Cheyenne"),
          position: CHEYENNE,
          infoWindow: InfoWindow(
              title: "Cheyenne",
              snippet: "State Captial"
          )
      );
      _markers["Cheyenne"] = cheyenne_marker;


    });
  }



 /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Maps Demo'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LARAMIE,
            zoom: 11.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

