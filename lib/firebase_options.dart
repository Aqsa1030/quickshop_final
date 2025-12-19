import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyD-pOL51-gFYlOrmHaspetr9x6Vd3iMle0', // Your web API key
    appId: '1:678180306000:web:a2f7e8646274e91607e555',
    messagingSenderId: '678180306000',
    projectId: 'quickshop-project-105',
    authDomain: 'quickshop-project-105.firebaseapp.com',
    storageBucket: 'quickshop-project-105.firebasestorage.app', // Updated storage bucket
    measurementId: 'G-08Y5HW9V73', // Add this measurementId
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBL8P0dFr8tCQLut5CzCJeh8jBq41NnKZg',
    appId: '1:678180306000:android:a31801e347605ab907e555',
    messagingSenderId: '678180306000',
    projectId: 'quickshop-project-105',
    storageBucket: 'quickshop-project-105.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPWLSSTbLVFlr4njl34sCqu8iqOrKXcOc',
    appId: '1:678180306000:ios:85f5346ede17d96907e555',
    messagingSenderId: '678180306000',
    projectId: 'quickshop-project-105',
    storageBucket: 'quickshop-project-105.appspot.com',
    iosBundleId: 'com.example.quickshopFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPWLSSTbLVFlr4njl34sCqu8iqOrKXcOc',
    appId: '1:678180306000:ios:85f5346ede17d96907e555',
    messagingSenderId: '678180306000',
    projectId: 'quickshop-project-105',
    storageBucket: 'quickshop-project-105.appspot.com',
    iosBundleId: 'com.example.quickshopFinal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-pOL51-gFYlOrmHaspetr9x6Vd3iMle0', // Same as web
    appId: '1:678180306000:web:f3fc7927b44a861007e555',
    messagingSenderId: '678180306000',
    projectId: 'quickshop-project-105',
    authDomain: 'quickshop-project-105.firebaseapp.com',
    storageBucket: 'quickshop-project-105.firebasestorage.app',
    measurementId: 'G-08Y5HW9V73',
  );
}