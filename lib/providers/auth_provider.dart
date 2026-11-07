import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.role == AppConstants.roleAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();
    _user = await _authService.loadCachedUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = AppConstants.roleCustomer,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> demoLoginCustomer() async {
    await signIn('foodie@cheatfood.com', 'cheatfood123');
  }

  Future<void> demoLoginAdmin() async {
    await signIn('admin@cheatfood.com', 'admin12345');
  }

  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile(String name, String phone) async {
    if (_user == null) return;
    _isLoading = true;
    notifyListeners();
    await _authService.updateProfile(name: name, phone: phone);
    _user = _authService.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
