import 'package:get/get.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/category_model.dart';
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
    return currentUser.value?.enableEODReminder ?? false;
  }

  /// Gets the current user's categories list
  /// Returns empty list if no user is loaded or no categories exist
  List<CategoryModel> getCategories() {
    return currentUser.value?.categories ?? [];
  }

  /// Updates categories list in the controller and Firestore
  /// [categories] - Updated list of CategoryModel
  /// Throws [Exception] on failure
  Future<void> updateCategories(List<CategoryModel> categories) async {
    try {
      final user = currentUser.value;
      if (user == null) {
        throw Exception('No user logged in');
      }
      
      final updatedUser = user.copyWith(
        categories: categories,
        updateOn: DateTime.now(),
      );
      
      await updateUserData(updatedUser);
    } catch (e) {
      throw Exception('Failed to update categories: ${e.toString()}');
    }
  }

  /// Adds a new category to the user's categories list
  /// [category] - CategoryModel to add
  /// Throws [Exception] on failure
  Future<void> addCategory(CategoryModel category) async {
    try {
      final categories = getCategories();
      
      // Check if category with same name already exists
      if (categories.any((c) => c.name == category.name)) {
        throw Exception('Category with this name already exists');
      }
      
      final updatedCategories = [...categories, category];
      await updateCategories(updatedCategories);
    } catch (e) {
      throw Exception('Failed to add category: ${e.toString()}');
    }
  }

  /// Updates an existing category in the user's categories list
  /// [oldCategory] - CategoryModel to replace
  /// [newCategory] - Updated CategoryModel
  /// Throws [Exception] on failure
  Future<void> updateCategory(
    CategoryModel oldCategory,
    CategoryModel newCategory,
  ) async {
    try {
      final categories = getCategories();
      final index = categories.indexWhere((c) => c.name == oldCategory.name);
      
      if (index == -1) {
        throw Exception('Category not found');
      }
      
      // Check if another category with the new name already exists
      if (oldCategory.name != newCategory.name &&
          categories.any((c) => c.name == newCategory.name)) {
        throw Exception('Category with this name already exists');
      }
      
      final updatedCategories = List<CategoryModel>.from(categories);
      updatedCategories[index] = newCategory;
      await updateCategories(updatedCategories);
    } catch (e) {
      throw Exception('Failed to update category: ${e.toString()}');
    }
  }

  /// Deletes a category from the user's categories list
  /// [category] - CategoryModel to delete
  /// Throws [Exception] on failure
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      final categories = getCategories();
      final updatedCategories = categories.where((c) => c.name != category.name).toList();
      await updateCategories(updatedCategories);
    } catch (e) {
      throw Exception('Failed to delete category: ${e.toString()}');
    }
  }
}

