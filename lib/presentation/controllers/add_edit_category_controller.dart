import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/user_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/service_locator.dart';
import '../../domain/models/category_model.dart';

/// Controller for managing add/edit category screen state
/// Handles category creation and editing
class AddEditCategoryController extends GetxController {
  final UserController _userController;

  /// Text controller for category name
  final TextEditingController nameController = TextEditingController();

  /// Text controller for hex code
  final TextEditingController hexCodeController = TextEditingController();

  /// Observable selected color
  final Rx<Color> selectedColor = AppColors.lightGreyColor.obs;

  /// Category being edited (null for add mode)
  CategoryModel? editingCategory;

  /// Context for showing messages
  BuildContext? _context;

  /// Constructor with dependency injection
  /// [userController] - User controller instance (defaults to ServiceLocator)
  AddEditCategoryController({UserController? userController})
      : _userController = userController ?? ServiceLocator.userController;

  /// Sets the context for showing messages
  /// [context] - BuildContext for messages
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Initializes the controller with category data if editing
  /// [category] - CategoryModel to edit (null for add mode)
  void initialize(CategoryModel? category) {
    editingCategory = category;
    if (category != null) {
      // Editing mode - populate with category data
      nameController.text = category.name;
      hexCodeController.text = category.hexCode;
      _updateColorFromHex(category.hexCode);
    } else {
      // Add mode - blank name and grey color
      nameController.text = '';
      hexCodeController.text = '#E0E0E0';
      _updateColorFromHex('#E0E0E0');
    }
  }

  /// Updates color from hex code string
  /// [hexCode] - Hex color code string
  void _updateColorFromHex(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      Color color;
      if (hex.length == 6) {
        color = Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        color = Color(int.parse(hex, radix: 16));
      } else {
        color = AppColors.lightGreyColor;
      }
      selectedColor.value = color;
    } catch (e) {
      selectedColor.value = AppColors.lightGreyColor;
    }
  }

  /// Updates hex code from color
  /// [color] - Color to convert to hex
  void updateColor(Color color) {
    selectedColor.value = color;
    final hex = color.value.toRadixString(16).substring(2).toUpperCase();
    hexCodeController.text = '#$hex';
  }

  /// Updates color when hex code text changes
  /// [hexCode] - Hex color code string
  void onHexCodeChanged(String hexCode) {
    _updateColorFromHex(hexCode);
  }

  /// Saves or updates the category
  /// Throws [Exception] on failure
  Future<void> saveCategory() async {
    try {
      final name = nameController.text.trim();
      final hexCode = hexCodeController.text.trim();

      // Validation
      if (name.isEmpty) {
        throw Exception(AppStrings.categoryNameCannotBeEmpty);
      }

      if (hexCode.isEmpty) {
        throw Exception(AppStrings.hexCodeCannotBeEmpty);
      }

      // Validate hex code format
      final hexPattern = RegExp(r'^#?[0-9A-Fa-f]{6}$');
      final cleanHex = hexCode.startsWith('#') ? hexCode : '#$hexCode';
      if (!hexPattern.hasMatch(cleanHex)) {
        throw Exception(AppStrings.invalidHexCodeFormat);
      }

      final category = CategoryModel(
        name: name,
        hexCode: cleanHex,
      );

      if (editingCategory != null) {
        // Update existing category
        await _userController.updateCategory(editingCategory!, category);
      } else {
        // Add new category
        await _userController.addCategory(category);
      }

      // Navigate back on success
      if (_context != null) {
        Navigator.of(_context!).pop();
      }
    } catch (e) {
      // Show error message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      rethrow;
    }
  }

  /// Deletes the category being edited
  /// Throws [Exception] on failure
  Future<void> deleteCategory() async {
    try {
      if (editingCategory == null) {
        throw Exception('No category to delete');
      }

      await _userController.deleteCategory(editingCategory!);

      // Show success message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.categoryDeletedSuccessfully),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Navigate back on success
      if (_context != null) {
        Navigator.of(_context!).pop();
      }
    } catch (e) {
      // Show error message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    hexCodeController.dispose();
    super.onClose();
  }
}

