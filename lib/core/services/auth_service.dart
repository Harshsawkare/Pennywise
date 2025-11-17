import '../../domain/repositories/auth_repository.dart';

/// Service layer for authentication operations
/// Acts as a use case layer between presentation and domain
class AuthService {
  final AuthRepository _authRepository;

  /// Constructor with dependency injection
  /// [authRepository] - Authentication repository instance
  AuthService(this._authRepository);

  /// Signs up a new user
  /// [phoneNumber] - User's phone number
  /// [password] - User's password
  /// Returns user ID on success
  /// Throws [Exception] on failure
  Future<String> signUp({
    required String phoneNumber,
    required String password,
  }) async {
    // Validate inputs
    if (phoneNumber.trim().isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    return await _authRepository.signUpWithPhoneAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  /// Signs in an existing user
  /// [phoneNumber] - User's phone number
  /// [password] - User's password
  /// Returns user ID on success
  /// Throws [Exception] on failure
  Future<String> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    // Validate inputs
    if (phoneNumber.trim().isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    return await _authRepository.signInWithPhoneAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  /// Signs out the current user
  /// Throws [Exception] on failure
  Future<void> signOut() async {
    return await _authRepository.signOut();
  }

  /// Gets the current user ID
  /// Returns null if no user is signed in
  String? getCurrentUserId() {
    return _authRepository.getCurrentUserId();
  }

  /// Checks if user is authenticated
  bool isAuthenticated() {
    return _authRepository.isAuthenticated();
  }
}

