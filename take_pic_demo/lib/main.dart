import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

///
/// simple example of how to take a photo. the same code could also used to pick a media file.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  final ImagePicker _picker = ImagePicker();
  XFile? photo = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //if image null show text
            photo != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(photo!.path),
                        fit: BoxFit.fill,
//                  width: MediaQuery.of(context).size.width,
//                  height: 300,
                      ),
                    ),
                  )
                : const Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPhoto,
        tooltip: 'take photo',
        child: const Icon(Icons.photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void getPhoto() {
    // source: ImageSource.gallery to pick a photo.   pickVideo( ... ) to change to videos.
    _picker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        photo = value;
      });
    });
  }
}
