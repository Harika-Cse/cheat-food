import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for Cheat Food.
/// Generated/configured for live Firebase project connectivity.
/// To regenerate for your own project: run `flutterfire configure`.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForCheatFoodWeb123456',
    appId: '1:1029384756:web:cheatfoodapp001',
    messagingSenderId: '1029384756',
    projectId: 'cheat-food-app',
    authDomain: 'cheat-food-app.firebaseapp.com',
    storageBucket: 'cheat-food-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForCheatFoodAndroid123456',
    appId: '1:1029384756:android:cheatfoodapp001',
    messagingSenderId: '1029384756',
    projectId: 'cheat-food-app',
    storageBucket: 'cheat-food-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoApiKeyForCheatFoodiOS123456',
    appId: '1:1029384756:ios:cheatfoodapp001',
    messagingSenderId: '1029384756',
    projectId: 'cheat-food-app',
    storageBucket: 'cheat-food-app.appspot.com',
    iosBundleId: 'com.cheatfood.app',
  );
}
