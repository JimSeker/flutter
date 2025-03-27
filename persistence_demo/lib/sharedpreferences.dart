import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class SharePrefWidget extends StatefulWidget {
  const SharePrefWidget({super.key});

  @override
  SharePrefState createState() => SharePrefState();
}

// this demos how to use key-value pairs in flutter

class SharePrefState extends State<SharePrefWidget> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// Load the initial counter value from persistent storage on start,
  /// or fallback to 0 if it doesn't exist.
  Future<void> _loadCounter() async {
    final asyncPrefs =  SharedPreferencesAsync();
    final counter = await asyncPrefs.getInt('counter') ?? 0;
    setState(()  {
      _counter = counter;
    });
  }

  /// After a click, increment the counter state and
  /// asynchronously save it to persistent storage.
  Future<void> _incrementCounter() async {
    final asyncPrefs = SharedPreferencesAsync();
    setState(()  {
      _counter ++;
      developer.log('Pressed $_counter times.');
    });
    await asyncPrefs.setInt('counter', _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Preferences')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Couter value'),
            Text('$_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
