import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';

/// Service layer for user data operations
/// Acts as a use case layer between presentation and domain
class UserService {
  final UserRepository _userRepository;

  /// Constructor with dependency injection
  /// [userRepository] - User repository instance
  UserService(this._userRepository);

  /// Fetches user data from Firestore
  /// [uid] - User's unique identifier
  /// Returns UserModel on success
  /// Throws [Exception] on failure
  Future<UserModel> getUserData(String uid) async {
    return await _userRepository.getUserData(uid);
  }

  /// Updates user data in Firestore
  /// [userModel] - UserModel with updated data
  /// Throws [Exception] on failure
  Future<void> updateUserData(UserModel userModel) async {
    return await _userRepository.updateUserData(userModel);
  }
}

