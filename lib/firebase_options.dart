// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAA-lCpO8H5JpO8Mkxws2Q5iqlo66ol1c',
    appId: '1:472530124951:android:7d89a81390da52230669d2',
    messagingSenderId: '472530124951',
    projectId: 'smack-talking-scoreboard',
    databaseURL: 'https://smack-talking-scoreboard.firebaseio.com',
    storageBucket: 'smack-talking-scoreboard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmJ7_ZkgFFssXjJk59yQswgXI5Tnf2AM8',
    appId: '1:472530124951:ios:a5546fc5d4c368170669d2',
    messagingSenderId: '472530124951',
    projectId: 'smack-talking-scoreboard',
    databaseURL: 'https://smack-talking-scoreboard.firebaseio.com',
    storageBucket: 'smack-talking-scoreboard.appspot.com',
    androidClientId: '472530124951-dgs7hbf6r8sakf02qp8k3lkgf02gdnug.apps.googleusercontent.com',
    iosClientId: '472530124951-knd5modd0bdho7s7dhvrqvgqh0ro386g.apps.googleusercontent.com',
    iosBundleId: 'com.zonkeyinventions.smackTalkingScoreboard',
  );
}