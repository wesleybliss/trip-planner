import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_dart/firebase_dart.dart' as fb_dart;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/utils/logger.dart';

/// Unified authentication service that works across all platforms using firebase_dart
class AuthService {
  final log = Logger("AuthService");

  fb_dart.FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google OAuth configuration for desktop
  final String _googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  final String _googleClientSecret = dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '';
  static const String _googleRedirectUri = 'http://localhost:8080/auth';
  static const String _googleAuthUrl = 'https://accounts.google.com/o/oauth2/v2/auth';
  static const String _googleTokenUrl = 'https://oauth2.googleapis.com/token';

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

  /// Check if running on desktop platform
  bool get _isDesktop {
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  /// Sign in with Google
  Future<AuthUser?> signInWithGoogle() async {
    if (_auth == null) {
      throw Exception('AuthService not initialized');
    }

    try {
      if (_isDesktop) {
        return await _signInWithGoogleDesktop();
      } else {
        return await _signInWithGoogleMobile();
      }
    } catch (e) {
      log.e('Error signing in with Google', e);
      rethrow;
    }
  }

  /// Sign in with Google on mobile platforms (Android/iOS)
  Future<AuthUser?> _signInWithGoogleMobile() async {
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
  }

  /// Sign in with Google on desktop platforms (Linux/Windows/macOS)
  Future<AuthUser?> _signInWithGoogleDesktop() async {
    log.d('Signing in with Google Desktop. Client ID: $_googleClientId');

    // Generate PKCE codes
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    // Build the authorization URL
    final authUrl = Uri.parse(_googleAuthUrl).replace(queryParameters: {
      'client_id': _googleClientId,
      'redirect_uri': _googleRedirectUri,
      'response_type': 'code',
      'scope': 'openid email profile',
      'access_type': 'offline',
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    });

    // Launch the browser and get the auth code
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: _googleRedirectUri,
      options: const FlutterWebAuth2Options(useWebview: false),
    );

    // Extract the authorization code from the callback URL
    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) {
      throw Exception('Failed to get authorization code');
    }

    // Exchange the auth code for tokens
    final tokenResponse = await http.post(
      Uri.parse(_googleTokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'code': code,
        'client_id': _googleClientId,
        'client_secret': _googleClientSecret,
        'redirect_uri': _googleRedirectUri,
        'grant_type': 'authorization_code',
        'code_verifier': codeVerifier,
      },
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Failed to exchange code for tokens: ${tokenResponse.body}');
    }

    final tokens = json.decode(tokenResponse.body);
    final accessToken = tokens['access_token'] as String?;
    final idToken = tokens['id_token'] as String?;

    if (accessToken == null || idToken == null) {
      throw Exception('Failed to get tokens from response');
    }

    // Create a new credential with the tokens
    final credential = fb_dart.GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    // Sign in with Firebase
    final userCredential = await _auth!.signInWithCredential(credential);
    final user = userCredential.user;
    return user != null ? AuthUser.fromDartUser(user) : null;
  }

  /// Generate a random PKCE code verifier
  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  /// Generate a PKCE code challenge from the verifier
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_auth != null) {
        await _auth!.signOut();
      }
      if (!_isDesktop) {
        await _googleSignIn.signOut();
      }
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
