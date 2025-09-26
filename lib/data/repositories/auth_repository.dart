import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User?> linkWithGoogle() async {
    final auth = _firebaseAuth;
    if (auth == null) {
      debugPrint('FirebaseAuth unavailable; skipping Google link.');
      return null;
    }

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = auth.currentUser;
      if (user == null) {
        // This should not happen if the user is already signed in anonymously
        return null;
      }

      final userCredential = await user.linkWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Failed to link with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    final auth = _firebaseAuth;
    if (auth == null) {
      debugPrint('FirebaseAuth unavailable; skipping signOut.');
      return;
    }
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}
