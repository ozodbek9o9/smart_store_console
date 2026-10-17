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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZS6pHahUisqp1PlttPNlGQyzRLaLIl3A',
    appId: '1:282827813787:android:f317b823bf54f27ebe273e',
    messagingSenderId: '282827813787',
    projectId: 'smart-store-7d83e',
    databaseURL: 'https://smart-store-7d83e-default-rtdb.firebaseio.com',
    storageBucket: 'smart-store-7d83e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcm6ukUmZRHdp7qQYkfyH41VXlvMq6eaI',
    appId: '1:282827813787:ios:685d7843577fcde9be273e',
    messagingSenderId: '282827813787',
    projectId: 'smart-store-7d83e',
    databaseURL: 'https://smart-store-7d83e-default-rtdb.firebaseio.com',
    storageBucket: 'smart-store-7d83e.firebasestorage.app',
    iosBundleId: 'com.example.smartStoreConsole',
  );
}
