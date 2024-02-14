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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDt8qMG96-RtHekLt_8jJTTPXH3oqawLdY',
    appId: '1:456919492230:web:db372221041c9cf392d307',
    messagingSenderId: '456919492230',
    projectId: 'lab3-c3fa2',
    authDomain: 'lab3-c3fa2.firebaseapp.com',
    storageBucket: 'lab3-c3fa2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBz6-n3v8M1YSMwhnvcJDC1CHgescv_R4c',
    appId: '1:456919492230:android:ea9a0be38b99ce3792d307',
    messagingSenderId: '456919492230',
    projectId: 'lab3-c3fa2',
    storageBucket: 'lab3-c3fa2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmm6jSkctuQbzgDZ_vAFQgRyP3yujLO-o',
    appId: '1:456919492230:ios:f24326e438e6b60e92d307',
    messagingSenderId: '456919492230',
    projectId: 'lab3-c3fa2',
    storageBucket: 'lab3-c3fa2.appspot.com',
    iosBundleId: 'com.example.lab3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDmm6jSkctuQbzgDZ_vAFQgRyP3yujLO-o',
    appId: '1:456919492230:ios:7996918b5d7c322c92d307',
    messagingSenderId: '456919492230',
    projectId: 'lab3-c3fa2',
    storageBucket: 'lab3-c3fa2.appspot.com',
    iosBundleId: 'com.example.lab3.RunnerTests',
  );
}
