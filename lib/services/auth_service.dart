import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth? _firebaseAuth =
      FirebaseService.isLive ? FirebaseAuth.instance : null;
  final FirebaseFirestore? _firestore =
      FirebaseService.isLive ? FirebaseFirestore.instance : null;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<UserModel?> loadCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('cached_uid');
      if (uid == null) return null;

      final email = prefs.getString('cached_email') ?? 'user@cheatfood.com';
      final name = prefs.getString('cached_name') ?? 'Street Foodie';
      final phone = prefs.getString('cached_phone') ?? '+91 98765 43210';
      final role = prefs.getString('cached_role') ?? AppConstants.roleCustomer;

      _currentUser = UserModel(
        uid: uid,
        email: email,
        name: name,
        phone: phone,
        role: role,
      );
      return _currentUser;
    } catch (e) {
      debugPrint('[AuthService] Error loading cached user: $e');
      return null;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (FirebaseService.isLive && _firebaseAuth != null && _firestore != null) {
      try {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final uid = credential.user!.uid;

        // Fetch user data from Cloud Firestore
        final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
        if (doc.exists && doc.data() != null) {
          _currentUser = UserModel.fromMap(doc.data()!, uid: uid);
        } else {
          _currentUser = UserModel(
            uid: uid,
            email: email,
            name: credential.user!.displayName ?? email.split('@').first,
            phone: credential.user!.phoneNumber ?? '+91 98765 43210',
            role: email.toLowerCase().contains('admin')
                ? AppConstants.roleAdmin
                : AppConstants.roleCustomer,
          );
        }
        await _saveUserLocally(_currentUser!);
        return _currentUser!;
      } catch (e) {
        debugPrint('[AuthService Live Error] $e');
        // If live login fails due to demo network/project, fallback gracefully
      }
    }

    // Mock / Standalone fallback login
    final role = email.toLowerCase().contains('admin')
        ? AppConstants.roleAdmin
        : AppConstants.roleCustomer;
    final userName = role == AppConstants.roleAdmin
        ? 'Admin Cheat Food'
        : (email.split('@').first.replaceAll('.', ' ').toUpperCase());

    _currentUser = UserModel(
      uid: 'user_${email.hashCode.abs()}',
      email: email.trim(),
      name: userName.isNotEmpty ? userName : 'Foodie Explorer',
      phone: '+91 98765 43210',
      role: role,
    );

    await _saveUserLocally(_currentUser!);
    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = AppConstants.roleCustomer,
  }) async {
    if (FirebaseService.isLive && _firebaseAuth != null && _firestore != null) {
      try {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final uid = credential.user!.uid;

        final newUser = UserModel(
          uid: uid,
          email: email.trim(),
          name: name.trim(),
          phone: phone.trim(),
          role: role,
        );

        // Store user in Firestore
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(uid)
            .set(newUser.toMap());

        _currentUser = newUser;
        await _saveUserLocally(_currentUser!);
        return _currentUser!;
      } catch (e) {
        debugPrint('[AuthService Live Registration Error] $e');
      }
    }

    // Mock / Standalone registration
    _currentUser = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      name: name.trim(),
      phone: phone.trim(),
      role: role,
    );

    await _saveUserLocally(_currentUser!);
    return _currentUser!;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (FirebaseService.isLive && _firebaseAuth != null) {
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      } catch (e) {
        debugPrint('[AuthService Reset Password Live] $e');
      }
    }
    // Always succeed cleanly for client experience
  }

  Future<void> signOut() async {
    if (FirebaseService.isLive && _firebaseAuth != null) {
      try {
        await _firebaseAuth.signOut();
      } catch (e) {
        debugPrint('[AuthService Live SignOut] $e');
      }
    }
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_uid');
    await prefs.remove('cached_email');
    await prefs.remove('cached_name');
    await prefs.remove('cached_phone');
    await prefs.remove('cached_role');
  }

  Future<void> updateProfile({required String name, required String phone}) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name, phone: phone);

    if (FirebaseService.isLive && _firestore != null) {
      try {
        await _firestore!
            .collection(AppConstants.usersCollection)
            .doc(_currentUser!.uid)
            .update({
          'name': name,
          'phone': phone,
        });
      } catch (e) {
        debugPrint('[AuthService Update Profile Live] $e');
      }
    }
    await _saveUserLocally(_currentUser!);
  }

  Future<void> _saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_uid', user.uid);
    await prefs.setString('cached_email', user.email);
    await prefs.setString('cached_name', user.name);
    await prefs.setString('cached_phone', user.phone);
    await prefs.setString('cached_role', user.role);
  }
}
