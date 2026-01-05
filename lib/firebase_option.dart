// GENERATED MANUALLY FROM FIREBASE CONFIG
// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not configured.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'This platform is not supported.',
        );
    }
  }

  /// ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDz2r2n-cpRBIIFftIQCCtKO1nHuOAOzoc',
    appId: '1:260246818462:android:eacc1b14cbe34e1e05b58f',
    messagingSenderId: '260246818462',
    projectId: 'crud-demo-c7939',
    storageBucket: 'crud-demo-c7939.firebasestorage.app',
  );

  /// IOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3dE2tNInyJALy7t3OrrbngpAly64Qyt0',
    appId: '1:260246818462:ios:8a86a6a844a86b0e05b58f',
    messagingSenderId: '260246818462',
    projectId: 'crud-demo-c7939',
    storageBucket: 'crud-demo-c7939.firebasestorage.app',
    iosBundleId: 'com.example.crudDemo',
  );
}
