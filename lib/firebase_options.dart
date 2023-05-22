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
    apiKey: 'AIzaSyCQ4f63RuLJw2CppdcISDDq7nnrspOQwAE',
    appId: '1:191588441480:web:17014f5efe444833ecae3d',
    messagingSenderId: '191588441480',
    projectId: 'flutter-todo-app-98c43',
    authDomain: 'flutter-todo-app-98c43.firebaseapp.com',
    databaseURL: 'https://flutter-todo-app-98c43-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-todo-app-98c43.appspot.com',
    measurementId: 'G-EWR2CZC9GV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4r5wbfv4L977-_wKZVy_Cnzfvndglp_c',
    appId: '1:191588441480:android:14c35e00529b14b0ecae3d',
    messagingSenderId: '191588441480',
    projectId: 'flutter-todo-app-98c43',
    databaseURL: 'https://flutter-todo-app-98c43-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-todo-app-98c43.appspot.com',
  );
}