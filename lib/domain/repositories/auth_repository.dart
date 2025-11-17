/// Domain layer repository interface for authentication
/// Defines the contract for authentication operations following clean architecture
abstract class AuthRepository {
  /// Signs up a new user with phone number and password
  /// [phoneNumber] - User's phone number (should include country code)
  /// [password] - User's password
  /// Returns the user ID on success
  /// Throws [Exception] on failure
  Future<String> signUpWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  });

  /// Signs in an existing user with phone number and password
  /// [phoneNumber] - User's phone number (should include country code)
  /// [password] - User's password
  /// Returns the user ID on success
  /// Throws [Exception] on failure
  Future<String> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  });

  /// Saves user data in Firestore for new users
  /// [uid] - User's unique identifier
  /// [phoneNumber] - User's phone number
  /// Throws [Exception] on failure
  Future<void> saveUserDataToFirestore({
    required String uid,
    required String phoneNumber,
  });

  /// Signs out the current user
  /// Throws [Exception] on failure
  Future<void> signOut();

  /// Gets the current user ID if authenticated
  /// Returns null if no user is signed in
  String? getCurrentUserId();

  /// Checks if a user is currently authenticated
  bool isAuthenticated();
}

