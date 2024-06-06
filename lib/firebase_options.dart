// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC3y9KRnkXcR_SiFYzsZlt4RyPltamNwtE',
    appId: '1:457707596927:web:4f0b263f068a241745634a',
    messagingSenderId: '457707596927',
    projectId: 'finearts-25dae',
    authDomain: 'finearts-25dae.firebaseapp.com',
    storageBucket: 'finearts-25dae.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYK3Wz16_f6aLdV4jzQAcyvCQsSt4Tjvg',
    appId: '1:457707596927:android:9742cb2788c3b42b45634a',
    messagingSenderId: '457707596927',
    projectId: 'finearts-25dae',
    storageBucket: 'finearts-25dae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwuFdCJ0D9Vu0dX-mbFk3qOgtlt373y5E',
    appId: '1:457707596927:ios:c8b9e2eeb726004145634a',
    messagingSenderId: '457707596927',
    projectId: 'finearts-25dae',
    storageBucket: 'finearts-25dae.appspot.com',
    iosBundleId: 'com.example.finearts',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDwuFdCJ0D9Vu0dX-mbFk3qOgtlt373y5E',
    appId: '1:457707596927:ios:c8b9e2eeb726004145634a',
    messagingSenderId: '457707596927',
    projectId: 'finearts-25dae',
    storageBucket: 'finearts-25dae.appspot.com',
    iosBundleId: 'com.example.finearts',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3y9KRnkXcR_SiFYzsZlt4RyPltamNwtE',
    appId: '1:457707596927:web:07cb719a8445dd1f45634a',
    messagingSenderId: '457707596927',
    projectId: 'finearts-25dae',
    authDomain: 'finearts-25dae.firebaseapp.com',
    storageBucket: 'finearts-25dae.appspot.com',
  );
}