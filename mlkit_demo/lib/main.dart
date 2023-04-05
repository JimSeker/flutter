// ignore_for_file: unused_import, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, avoid_print

import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// note in the android/app/build.gradle min sdk is hard set to 24, since flutter is using 16! for dumb reason and mlKit won't support it.
/// do we need to edit the androidmanifext.xml and vision dependencies?
///   there example code has it, so I added as well.
/// So this example will take a picture and then using vision from mlkit to draw on it.
///  https://github.com/bharat-biradar/Google-Ml-Kit-plugin
/// This example uses bits and pieces of the mlkit example code but for a still frame
/// also their code is bad style and in places just hacked together.
///    I've attempted to clean up the pieces I used.
/// the coordinates_translator and face_detector_painter files are not used, but
/// were used as reference.

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'mlKit demo page'),
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
  late InputImage inputImageG;

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
      body: photo != null
          ? FittedBox(
              child: SizedBox(
                  width: image?.width.toDouble(),
                  height: image?.height.toDouble(),
                  child: CustomPaint(
                      painter: FacePainter(image: image!, faces: faces))))
          : const Text(
              "No Image",
              style: TextStyle(fontSize: 20),
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
    _picker.pickImage(source: ImageSource.camera).then((value) async {
      //retruns an Xfile?  we need a file
      photo = value;
      if (photo == null) return;

      InputImage inputImage = InputImage.fromFilePath(photo!.path);
      // var data = inputImage.bytes; //still need the image to draw.
      final data = await photo?.readAsBytes(); //actually get the data.
      final faceslocal = await _faceDetector.processImage(inputImage);

      decodeImageFromList(data!).then((value) {
        setState(() {
          photo = photo;
          image = value;
          faces = faceslocal;
        });
      });
    });
  }
}

class FacePainter extends CustomPainter {
  FacePainter({required this.image, required this.faces});

  ui.Image image;
  List<Face> faces;

  final List<FaceContourType> listFaceContourtype = <FaceContourType>[
    FaceContourType.face,
    FaceContourType.leftEyebrowTop,
    FaceContourType.leftEyebrowBottom,
    FaceContourType.rightEyebrowTop,
    FaceContourType.rightEyebrowBottom,
    FaceContourType.leftEye,
    FaceContourType.rightEye,
    FaceContourType.upperLipTop,
    FaceContourType.upperLipBottom,
    FaceContourType.lowerLipTop,
    FaceContourType.lowerLipBottom,
    FaceContourType.noseBridge,
    FaceContourType.noseBottom,
    FaceContourType.leftCheek,
    FaceContourType.rightCheek,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;

    for (final Face face in faces) {
      //draw the bounding box first.
      canvas.drawRect(face.boundingBox, paint);

      //now draw all the contour as small dots for the faces.
      for (final FaceContourType type in listFaceContourtype) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(point.x.toDouble(), point.y.toDouble()), 5, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      image != oldDelegate.image || faces != oldDelegate.faces;
}
