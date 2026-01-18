import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../services/auth_service.dart';
import 'logger.dart';
import 'package:firebase_dart/firebase_dart.dart' as fb_dart;
import '../firebase_options.dart';

/// Initializes Firebase using firebase_dart for all platforms
/// Returns the initialized AuthService instance
Future<AuthService> initializeFirebase() async {
  final log = Logger('utils/firebase');

  log.d('[Firebase] Starting initialization with firebase_dart...');
  log.d('[Firebase] kDebugMode = $kDebugMode');
  log.d('[Firebase] kReleaseMode = $kReleaseMode');

  // Initialize AuthService
  final authService = AuthService();

  // Setup firebase_dart implementation
  String? storagePath;
  if (!kIsWeb) {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      storagePath = appDocDir.path;
    } catch (e) {
      log.e('[Firebase] Failed to get application documents directory: $e');
    }
  }

  fb_dart.FirebaseDart.setup(storagePath: storagePath);
  log.d('[Firebase] FirebaseDart implementation setup complete with storagePath: $storagePath');

  // Get the appropriate platform options
  final options = DefaultFirebaseOptions.currentPlatform;

  // Initialize firebase_dart
  final app = await fb_dart.Firebase.initializeApp(
    options: fb_dart.FirebaseOptions(
      apiKey: options.apiKey,
      appId: options.appId,
      messagingSenderId: options.messagingSenderId,
      projectId: options.projectId,
      authDomain: options.authDomain,
      storageBucket: options.storageBucket,
    ),
  );
  log.d('[Firebase] firebase_dart app initialized');

  // Get auth instance from the initialized app
  final auth = fb_dart.FirebaseAuth.instanceFor(app: app);

  // Initialize auth service with firebase_dart
  authService.initWithAuth(auth);
  log.d('[Firebase] firebase_dart initialized successfully');

  log.d('[Firebase] Initialization complete!');
  return authService;
}
