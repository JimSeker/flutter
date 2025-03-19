import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

///This code is based off Sharan Singh code in https://github.com/sharansingh00002/draw
/// which badly out of date (flutter 1.0), but the framework was still workable, so I fixed and changed
/// a number of pieces to make it work again.

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Drawing Demo Page'),
      debugShowCheckedModeBanner: false,
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
  List<DrawingPoints> points = [];
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;

  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.greenAccent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.album),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.StrokeWidth) {
                                  showBottomList = !showBottomList;
                                }
                                selectedMode = SelectedMode.StrokeWidth;
                              });
                            }),
                        IconButton(
                            icon: const Icon(Icons.opacity),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.Opacity) {
                                  showBottomList = !showBottomList;
                                }
                                selectedMode = SelectedMode.Opacity;
                              });
                            }),
                        IconButton(
                            icon: const Icon(Icons.color_lens),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.Color) {
                                  showBottomList = !showBottomList;
                                }
                                selectedMode = SelectedMode.Color;
                              });
                            }),
                        IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                showBottomList = false;
                                points.clear();
                              });
                            }),
                      ],
                    ),
                    Visibility(
                      visible: showBottomList,
                      child: (selectedMode == SelectedMode.Color)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: getColorList(),
                            )
                          : Slider(
                              value: (selectedMode == SelectedMode.StrokeWidth)
                                  ? strokeWidth
                                  : opacity,
                              max: (selectedMode == SelectedMode.StrokeWidth)
                                  ? 50.0
                                  : 1.0,
                              min: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  if (selectedMode ==
                                      SelectedMode.StrokeWidth) {
                                    strokeWidth = val;
                                  } else {
                                    opacity = val;
                                  }
                                });
                              }),
                    ),
                  ],
                ),
              )),
        ),
        body: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(DrawingPoints(
                    points: details.localPosition,  //for the location in the widget, which is what we need.
                  //  points: details.globalPosition,  //for the screen location.
                    paint: Paint()
                      ..strokeCap = strokeCap
                      ..color = selectedColor.withValues(alpha: opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanStart: (details) {
              setState(() {
                points.add(DrawingPoints(
                    points: details.localPosition,
                    paint: Paint()
                      ..strokeCap = strokeCap
                      ..color = selectedColor.withValues(alpha: opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(DrawingPoints(
                    points: const Offset(-1.0, -1.0),
                    paint: Paint()
                      ..strokeCap = strokeCap
                      ..color = selectedColor.withValues(alpha: opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(pointsList: points),
            )));
  }

  getColorList() {
    List<Widget> listWidget = [];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (color) {
                      pickerColor = color;
                    },
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() => selectedColor = pickerColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < (pointsList.length - 1); i++) {
      if (pointsList[i].points.dx != -1 && pointsList[i + 1].points.dx != -1) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i].points.dx != -1 &&
          pointsList[i + 1].points.dx == -1) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingPoints {
  late final Offset points;
  late final Paint paint;

  DrawingPoints({required this.points, required this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
