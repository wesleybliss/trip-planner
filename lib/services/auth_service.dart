import 'dart:async';
import 'package:firebase_dart/firebase_dart.dart' as fb_dart;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trip_planner/utils/logger.dart';

/// Unified authentication service that works across all platforms using firebase_dart
class AuthService {
  final log = Logger("AuthService");
  
  fb_dart.FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  /// Stream of auth state changes
  Stream<AuthUser?> get authStateChanges {
    if (_auth != null) {
      return _auth!.authStateChanges().map((user) => 
        user != null ? AuthUser.fromDartUser(user) : null
      );
    }
    return Stream.value(null);
  }
  
  /// Current authenticated user
  AuthUser? get currentUser {
    if (_auth != null) {
      final user = _auth!.currentUser;
      return user != null ? AuthUser.fromDartUser(user) : null;
    }
    return null;
  }
  
  /// Initialize with firebase_dart auth
  void initWithAuth(fb_dart.FirebaseAuth auth) {
    _auth = auth;
  }
  
  /// Sign in with Google
  Future<AuthUser?> signInWithGoogle() async {
    if (_auth == null) {
      throw Exception('AuthService not initialized');
    }

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = fb_dart.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth!.signInWithCredential(credential);
      final user = userCredential.user;
      return user != null ? AuthUser.fromDartUser(user) : null;
    } catch (e) {
      log.e('Error signing in with Google', e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_auth != null) {
        await _auth!.signOut();
      }
      await _googleSignIn.signOut();
    } catch (e) {
      log.e('Error signing out', e);
    }
  }
  
  /// Get ID token for authenticated requests
  Future<String?> getIdToken() async {
    try {
      if (_auth != null) {
        final user = _auth!.currentUser;
        if (user != null) {
          return await user.getIdToken();
        }
      }
      return null;
    } catch (e) {
      log.e('Failed to get ID token', e);
      return null;
    }
  }
}

/// Unified user model that works with firebase_dart
class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final bool emailVerified;
  
  AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.emailVerified = false,
  });
  
  factory AuthUser.fromDartUser(fb_dart.User user) {
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
    );
  }
}
