import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth? _firebaseAuth;

  bool get isAvailable => _firebaseAuth != null;

  Stream<User?> get authStateChanges {
    final auth = _firebaseAuth;
    if (auth == null) {
      return Stream<User?>.empty();
    }
    return auth.authStateChanges();
  }

  User? getCurrentUser() {
    return _firebaseAuth?.currentUser;
  }

  Future<User?> signInAnonymously() async {
    final auth = _firebaseAuth;
    if (auth == null) {
      debugPrint('FirebaseAuth unavailable; skipping anonymous sign-in.');
      return null;
    }
    try {
      final userCredential = await auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      debugPrint('Failed to sign in anonymously: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    final auth = _firebaseAuth;
    if (auth == null) {
      debugPrint('FirebaseAuth unavailable; skipping signOut.');
      return;
    }
    await auth.signOut();
  }
}
