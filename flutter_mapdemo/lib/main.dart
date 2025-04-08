import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//note, in the android build.gradle, since flutter thinks 16 is the right sdk and it's not
//manually set to 24 for maps.

void main() {
  runApp(const MyApp());
}

const LatLng CHEYENNE = LatLng(41.1400, -104.8197);
const LatLng LARAMIE = LatLng(41.312928, -105.587253);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
   
    setState(() {
      _markers.clear();
      Marker laramieMarker = const Marker(
          markerId: MarkerId("Laramie"),
          position: LARAMIE,
          infoWindow:
              InfoWindow(title: "Laramie", snippet: "home of UW"));
      _markers["Laramie"] = laramieMarker;
      Marker cheyenneMarker = const Marker(
          markerId: MarkerId("Cheyenne"),
          position: CHEYENNE,
          infoWindow:
              InfoWindow(title: "Cheyenne", snippet: "State Capital"));
      _markers["Cheyenne"] = cheyenneMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LARAMIE,
            zoom: 11.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
