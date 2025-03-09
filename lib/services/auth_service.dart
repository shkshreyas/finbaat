import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  bool _isInitialized = false;

  AuthService() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _isInitialized = true;
    } catch (e) {
      print('Firebase not initialized: $e');
      _isInitialized = false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    if (!_isInitialized) throw Exception('Firebase not initialized');

    final user = _auth!.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore!.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, user.uid);
      }
    } catch (e) {
      print('Error getting user data: $e');
    }

    return UserModel(uid: user.uid, email: user.email!);
  }

  Future<UserModel> signIn(String email, String password) async {
    if (!_isInitialized) throw Exception('Firebase not initialized');

    try {
      final result = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;

      try {
        final doc = await _firestore!.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromMap(doc.data()!, user.uid);
        }
      } catch (e) {
        print('Error getting user data: $e');
      }

      return UserModel(uid: user.uid, email: user.email!);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    if (!_isInitialized) throw Exception('Firebase not initialized');

    try {
      final result = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user!;
      final userModel = UserModel(uid: user.uid, email: email, name: name);

      try {
        await _firestore!
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      } catch (e) {
        print('Error saving user data: $e');
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    if (!_isInitialized) return; // Just return if Firebase isn't initialized

    try {
      await _auth!.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email');
        case 'wrong-password':
          return Exception('Incorrect password');
        case 'email-already-in-use':
          return Exception('Email is already in use');
        case 'weak-password':
          return Exception('Password is too weak');
        case 'invalid-email':
          return Exception('Invalid email format');
        default:
          return Exception(e.message ?? 'Authentication failed');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
