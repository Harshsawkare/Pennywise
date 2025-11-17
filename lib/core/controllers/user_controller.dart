import 'package:get/get.dart';
import '../../domain/models/user_model.dart';
import '../services/user_service.dart';
import '../di/service_locator.dart';

/// Global user controller managing current user state
/// Follows GetX state management pattern and SOLID principles
class UserController extends GetxController {
  final UserService _userService;

  /// Observable current user model
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// Constructor with dependency injection
  /// [userService] - User service instance (defaults to ServiceLocator)
  UserController({UserService? userService})
      : _userService = userService ?? ServiceLocator.userService;

  /// Loads user data from Firestore and sets it in the controller
  /// [uid] - User's unique identifier
  /// Throws [Exception] on failure
  Future<void> loadUserData(String uid) async {
    try {
      final userModel = await _userService.getUserData(uid);
      currentUser.value = userModel;
    } catch (e) {
      throw Exception('Failed to load user data: ${e.toString()}');
    }
  }

  /// Updates user data in the controller and Firestore
  /// [userModel] - Updated UserModel
  /// Throws [Exception] on failure
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _userService.updateUserData(userModel);
      currentUser.value = userModel;
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }

  /// Clears current user data (on logout)
  void clearUser() {
    currentUser.value = null;
  }

  /// Gets the current user's selected currency
  /// Returns default 'INR' if no user is loaded
  String getSelectedCurrency() {
    return currentUser.value?.selectedCurrency ?? 'INR';
  }

  /// Gets the current user's 24h clock setting
  /// Returns default false if no user is loaded
  bool getIs24h() {
    return currentUser.value?.is24h ?? false;
  }

  /// Gets the current user's EOD reminder setting
  /// Returns default true if no user is loaded
  bool getEnableEODReminder() {
    return currentUser.value?.enableEODReminder ?? true;
  }
}

