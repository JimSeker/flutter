// ignore_for_file: unused_import, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// note in the android/app/build.gradle min sdk is hard set to 24, since flutter is using 16! for dumb reason and mlKit won't support it.
/// do we ened to edit the androidmanifext.xml and vision dependencies?
/// So this example will take a picture and then useing vision from mlkit to draw on it.
///
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
  ui.Image? image;
  List<Face> faces = [];
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

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
                ? FittedBox(
                    child: SizedBox(
                        width: image?.width.toDouble(),
                        height: image?.height.toDouble(),
                        child: CustomPaint(
                            painter: FacePainter(image: image!, faces: faces))))
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
    //so dumb set of casts.
    // source: ImageSource.gallery to pick a photo.   pickVideo( ... ) to change to videos.
    // _picker.pickImage(source: ImageSource.camera).then((value) {
    //   photo = value;
    //   photo?.readAsBytes().then((data) {
    //     decodeImageFromList(data).then((value) {
    //       setState(() {
    //         photo = photo;
    //         image = value;
    //       });
    //     });
    //   });
    // });
    _picker.pickImage(source: ImageSource.camera).then((value) async {
      //retruns an Xfile?  we need a file
      photo = value;
      if (photo == null) return;

      InputImage inputImage = InputImage.fromFilePath(photo!.path);
      final data = inputImage.bytes; //still need the image to draw.
      final faceslocal = await _faceDetector.processImage(inputImage);
      decodeImageFromList(data!).then((value) {
        setState(() {
          photo = photo;
          image = value;
          faces = faceslocal;
        });
      });
    });
    //so try and run the detector here.
    // _faceDetector.processImage(inputImage).then((value) {
    //
    // });
  }
}

class FacePainter extends CustomPainter {
  FacePainter({required this.image, required this.faces});

  ui.Image image;
  List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(faces[i].boundingBox, Paint());
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      image != oldDelegate.image || faces != oldDelegate.faces;
}
