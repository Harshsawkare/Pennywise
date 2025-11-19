import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Notifier that listens to Firebase Auth state changes
/// Used by go_router to refresh routes when auth state changes
class AuthStateNotifier extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authStateSubscription;

  AuthStateNotifier({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    // Listen to auth state changes
    _authStateSubscription = _firebaseAuth.authStateChanges().listen(
      (User? user) {
        // Notify listeners when auth state changes
        notifyListeners();
      },
    );
  }

  /// Checks if user is currently authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Gets the current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

