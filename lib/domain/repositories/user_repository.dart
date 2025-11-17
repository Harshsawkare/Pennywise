import '../models/user_model.dart';

/// Domain layer repository interface for user data operations
/// Defines the contract for user data operations following clean architecture
abstract class UserRepository {
  /// Fetches user data from Firestore by user ID
  /// [uid] - User's unique identifier
  /// Returns UserModel on success
  /// Throws [Exception] on failure
  Future<UserModel> getUserData(String uid);

  /// Updates user data in Firestore
  /// [userModel] - UserModel with updated data
  /// Throws [Exception] on failure
  Future<void> updateUserData(UserModel userModel);
}

