import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool _isLive = false;

  static bool get isInitialized => _isInitialized;
  static bool get isLive => _isLive;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      _isLive = true;
      debugPrint('[FirebaseService] Firebase successfully initialized in LIVE mode.');
    } catch (e) {
      _isInitialized = true;
      _isLive = false;
      debugPrint('[FirebaseService] Firebase initialization notice: $e');
      debugPrint('[FirebaseService] Running Cheat Food in dynamic local/in-memory engine.');
    }
  }
}
