import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/auth_repository.dart';

/// Data layer implementation of AuthRepository
/// Handles phone number + password authentication using Firebase Auth
/// Uses email/password authentication with phone number as email identifier
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Constructor with dependency injection
  /// [firebaseAuth] - Firebase Auth instance (defaults to FirebaseAuth.instance)
  /// [firestore] - Firebase Firestore instance (defaults to FirebaseFirestore.instance)
  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> signUpWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Normalize phone number (ensure it starts with +)
      final normalizedPhone = _normalizePhoneNumber(phoneNumber);

      // Convert phone number to email format for Firebase Auth
      // Firebase Auth requires email format, so we use phone@pennywise.app
      final email = _phoneToEmail(normalizedPhone);

      // Create user with Firebase Auth (handles password hashing securely)
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      if (userId == null) {
        throw Exception('Failed to create user account');
      }

      // Save user data to Firestore
      await saveUserDataToFirestore(
        uid: userId,
        phoneNumber: normalizedPhone,
      );

      return userId;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<String> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      // Normalize phone number
      final normalizedPhone = _normalizePhoneNumber(phoneNumber);

      // Convert phone number to email format for Firebase Auth
      final email = _phoneToEmail(normalizedPhone);

      // Sign in with Firebase Auth (handles password verification securely)
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;
      if (userId == null) {
        throw Exception('Failed to sign in');
      }

      return userId;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  String? getCurrentUserId() {
    // Return Firebase Auth current user ID
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  bool isAuthenticated() {
    // User is authenticated if Firebase Auth has a current user
    return _firebaseAuth.currentUser != null;
  }

  /// Normalizes phone number to ensure it starts with +
  /// [phoneNumber] - Raw phone number input
  /// Returns normalized phone number with country code
  String _normalizePhoneNumber(String phoneNumber) {
    String normalized = phoneNumber.trim();
    
    // Remove all non-digit characters except +
    normalized = normalized.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it doesn't start with +, add +91 (default to India)
    if (!normalized.startsWith('+')) {
      // If it starts with 91, add +
      if (normalized.startsWith('91') && normalized.length > 2) {
        normalized = '+$normalized';
      } else {
        // Otherwise, assume India number and add +91
        normalized = '+91$normalized';
      }
    }
    
    return normalized;
  }

  /// Converts phone number to email format for Firebase Auth
  /// Firebase Auth requires email format, so we use phone@pennywise.app
  /// [phoneNumber] - Normalized phone number (e.g., +911234567890)
  /// Returns email-formatted string (e.g., +911234567890@pennywise.app)
  String _phoneToEmail(String phoneNumber) {
    // Replace + with a safe character for email (or remove it)
    // Using underscore to preserve the + indicator
    final safePhone = phoneNumber.replaceAll('+', 'plus');
    return '$safePhone@pennywise.app';
  }

  @override
  Future<void> saveUserDataToFirestore({
    required String uid,
    required String phoneNumber,
  }) async {
    try {
      final now = DateTime.now();
      final userRef = _firestore.collection('users').doc(uid);

      // Create new user document
      await userRef.set({
        'uid': uid,
        'phoneNo': phoneNumber,
        'createdOn': Timestamp.fromDate(now),
        'updateOn': Timestamp.fromDate(now),
        'isActive': true,
        'selectedCurrency': 'INR',
        'is24h': true,
        'enableEODReminder': true,
      });
    } catch (e) {
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  /// Handles Firebase Auth exceptions and converts them to user-friendly messages
  /// [e] - FirebaseAuthException to handle
  /// Returns Exception with user-friendly message
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('The password provided is too weak');
      case 'user-not-found':
        return Exception('No account found with this phone number');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'email-already-in-use':
        return Exception('An account already exists with this phone number');
      case 'invalid-email':
        return Exception('Invalid phone number format');
      case 'invalid-credential':
        return Exception('Incorrect password');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later');
      case 'operation-not-allowed':
        return Exception('This operation is not allowed');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection');
      default:
        return Exception('Authentication failed: ${e.message ?? e.code}');
    }
  }
}

