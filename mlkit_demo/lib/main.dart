// ignore_for_file: unused_import, use_key_in_widget_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, avoid_print

import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as image;

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
  ui.Image? myImage;
  List<Face> faces = [];
  late InputImage inputImageG;
  // add any more image declarations here.
  late ui.Image duck;

  String information = "Not Ready";

  @override
  initState() {
    super.initState();
     loadImages();

  }

  //load all the images here from assets, once they are all loaded the app
  // will be ready to take a picture and then process it.
  Future<void> loadImages() async {
    duck = await getUiImage("assets/duck128.png", 128,128) ;
    setState(() {
      information = "Ready, press FAB to load a picture.";
    });
  }

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableTracking: true,
      enableLandmarks: true,
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
                  width: myImage?.width.toDouble(),
                  height: myImage?.height.toDouble(),
                  child: CustomPaint(
                      painter: FacePainter(myImage: myImage!, duck: duck, faces: faces))))
          : Text(
              information,
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
          myImage = value;
          faces = faceslocal;
        });
      });
    });
  }

  //this is a helper to load images and resize to your needs.
  Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
    image.Image resizeImage = image.copyResize(baseSizeImage!, height: height, width: width);
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

}

/// this is the custom painter that draws the image and the faces on top of it.
/// For new images, you need to add them to the constructor.  The CustomPainter
/// can't load the images itself, because that an async and then it just won't
/// wait on the paint method.  so you get blank images.
class FacePainter extends CustomPainter {
  FacePainter({required this.myImage, required this.faces, required this.duck});

  ui.Image myImage;
  List<Face> faces;
  ui.Image duck;

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

  final List<FaceLandmarkType> listLandMarktype = <FaceLandmarkType>[
    FaceLandmarkType.leftEar,
    FaceLandmarkType.rightEar,
    FaceLandmarkType.leftMouth,
    FaceLandmarkType.rightMouth,
    FaceLandmarkType.bottomMouth,
    FaceLandmarkType.noseBase,
    FaceLandmarkType.leftCheek,
    FaceLandmarkType.rightCheek,
    FaceLandmarkType.leftEye,
    FaceLandmarkType.rightEye,
  ];

  @override
  paint(Canvas canvas, Size size) async {
    canvas.drawImage(myImage, Offset.zero, Paint());
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;
    final Paint paintBlue = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.blue;



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

      //draw the landmarks as small dots.
      for (final FaceLandmarkType type in listLandMarktype) {
        print("landmark: " );
        final faceLandmark = face.landmarks[type];
        if (faceLandmark != null) {
          print ("there is a landmark");
          canvas.drawCircle(
              Offset(faceLandmark.position.x.toDouble(),
                  faceLandmark.position.y.toDouble()),
              30,
              paintBlue);
        }
      }
      //draw duck on the left cheek
      final Point leftCheek = face.landmarks[FaceLandmarkType.leftCheek]!.position;
      Offset offset = Offset(leftCheek.x.toDouble(), leftCheek.y.toDouble());
      canvas.drawImage(duck, offset, paint);

    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      myImage != oldDelegate.myImage || faces != oldDelegate.faces;



}
