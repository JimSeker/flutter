// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCShEvM2NTGLNXiCAU70hs9Qb8w-WE1Q4w',
    appId: '1:426330183358:web:a0a495b885a465018070ef',
    messagingSenderId: '426330183358',
    projectId: 'fir-mlkit-62d91',
    authDomain: 'fir-mlkit-62d91.firebaseapp.com',
    databaseURL: 'https://fir-mlkit-62d91.firebaseio.com',
    storageBucket: 'fir-mlkit-62d91.appspot.com',
    measurementId: 'G-XZJXJTBZNN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBicTAJbCLX6ZD3PzzFTiKck6iSzvo_Sbo',
    appId: '1:426330183358:android:4dbb483411c2b80e8070ef',
    messagingSenderId: '426330183358',
    projectId: 'fir-mlkit-62d91',
    databaseURL: 'https://fir-mlkit-62d91.firebaseio.com',
    storageBucket: 'fir-mlkit-62d91.appspot.com',
  );
}