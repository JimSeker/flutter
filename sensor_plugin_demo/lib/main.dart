// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';

//https://plus.fluttercommunity.dev/docs/sensors_plus/usage
//https://github.com/fluttercommunity/plus_plugins/tree/main/packages/
//https://pub.dev/packages/battery_plus/example
//https://pub.dev/packages/sensors_plus/example

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  List<double>? _barometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final Battery _battery = Battery();

  BatteryState? _batteryState;

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer =
        _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1))
            .toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final barometer =
    _barometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(child: SizedBox(width: 300, height: 50,
              child: Center(child: Text('Accelerometer: $accelerometer')),
          ), ),
          Card(child: SizedBox(width: 300, height: 50,
              child: Center(child: Text('UserAccelerometer: $userAccelerometer')),
          ),),
          Card(child: SizedBox(width: 300, height: 50,
              child: Center(child: Text('Gyroscope: $gyroscope')),
          ),),
          Card(child: SizedBox(width: 300, height: 50,
              child: Center(child: Text('Magnetometer: $magnetometer')),
          ),),
          Card(child: SizedBox(width: 300, height: 50,
            child: Center(child: Text('Barometer: $barometer')),
          ),),
          Card(child: SizedBox(width: 300, height: 50,
              child: Center(child: Text('$_batteryState')),
          ),),
          ElevatedButton(
            onPressed: () async {
              final batteryLevel = await _battery.batteryLevel;
              // ignore: unawaited_futures
              if (context.mounted) {  //async context can be a problem, so check.
                showDialog<void>(
                  context: context,
                  builder:
                      (_) =>
                      AlertDialog(
                        content: Text('Battery: $batteryLevel%'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                );
              }
            },
            child: const Text('Get battery level'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEventStream().listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream().listen((GyroscopeEvent event) {
        setState(() {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      magnetometerEventStream().listen((MagnetometerEvent event) {
          setState(() {
           _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        }, cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
        barometerEventStream().listen( (BarometerEvent event) {
            setState(() {
              _barometerValues = <double>[event.pressure];
            });
          },
          onError: (error) { print('Error: $error'); },
          cancelOnError: true,
        )
    );
    //now add the battery
    //  _battery.batteryState.then(_updateBatteryState);
    _streamSubscriptions.add(
      _battery.onBatteryStateChanged.listen((BatteryState state) {
        if (_batteryState == state) return;
        setState(() {
          _batteryState = state;
        });
      }),
    );
  }
}
