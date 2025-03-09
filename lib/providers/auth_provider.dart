import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _loading = true;
  bool _isFirebaseAvailable = true;
  bool _bypassAuth = false; // For testing when Firebase is not set up

  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null || _bypassAuth;
  bool get isFirebaseAvailable => _isFirebaseAvailable;
  bool get bypassAuth => _bypassAuth;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _loading = true;
    notifyListeners();

    try {
      final user = await _authService.getCurrentUser();
      _user = user;
      _isFirebaseAvailable = true;
    } catch (e) {
      print('Auth provider initialization error: $e');
      _user = null;
      _isFirebaseAvailable = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Enable bypass auth for testing
  void setBypassAuth(bool value) {
    _bypassAuth = value;
    notifyListeners();
  }

  Future<void> signInWithoutFirebase(String email) async {
    try {
      _loading = true;
      notifyListeners();

      // Create a mock user for testing
      _user = UserModel(uid: 'test-user-id', email: email, name: 'Test User');
      _bypassAuth = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      final user = await _authService.signIn(email, password);
      _user = user;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.signUp(email, password, name);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.signOut();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
