import 'package:get/get.dart';
import '../../core/controllers/user_controller.dart';
import '../../core/di/service_locator.dart';
import '../../domain/models/category_model.dart';

/// Controller for managing categories screen state
/// Handles category list display and navigation
class CategoriesController extends GetxController {
  final UserController _userController;

  /// Observable list of categories
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  /// Constructor with dependency injection
  /// [userController] - User controller instance (defaults to ServiceLocator)
  CategoriesController({UserController? userController})
      : _userController = userController ?? ServiceLocator.userController;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    
    // Listen to user changes to update categories
    ever(_userController.currentUser, (_) {
      loadCategories();
    });
  }

  /// Loads categories from user controller
  void loadCategories() {
    categories.value = _userController.getCategories();
  }
}

