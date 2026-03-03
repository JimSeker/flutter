import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///simple app to demo how the http plugin works
///as well as the future widget.

void main() {
  runApp(const MyApp());
}

bool kDebugMode = true; // Set to true to enable debug mode, false to disable. You can set this to false in production.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Fetch Data Example'),
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
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return title, if title is null, return no title instead.
                return Text(snapshot.data?.title ?? "no title");
              } else if (snapshot.hasError) {
                //on error just return the error.
                return Text("${snapshot.error}");
              } else {
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<Album> fetchAlbum() async {
  //var parameters = <String, String>{};
  var uri = Uri.parse('http://jsonplaceholder.typicode.com/albums/1');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //A note, sometimes cloudflare has not allowed the android device to read the response, so it will return a 403 error, but the app is still working as intended, just the server is blocking the request. You can test this by running the app on an emulator and checking the logs.
    if (kDebugMode) {
      print("------------------");
      print("Failed to load album");
      print(response.statusCode);
      print(response.body);
      print("------------------");
    }
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json['title']);
  }
}
