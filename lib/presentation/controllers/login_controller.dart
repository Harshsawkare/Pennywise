import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/di/service_locator.dart';

/// Login controller managing the state and business logic for the login screen
/// Follows GetX state management pattern and SOLID principles
class LoginController extends GetxController {
  // Text editing controllers for form fields
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Focus nodes for managing field focus
  final FocusNode contactFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Observable state variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;

  // BuildContext for navigation and snackbars
  BuildContext? _context;

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to validate form
    _setupFormValidation();
  }

  /// Sets up form validation listeners
  /// Validates form whenever any field changes
  void _setupFormValidation() {
    contactController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  /// Validates the entire form and updates isFormValid state
  /// Checks if all fields are filled
  void validateForm() {
    final contact = contactController.text.trim();
    final password = passwordController.text.trim();

    final isValid = contact.isNotEmpty && password.isNotEmpty;
    isFormValid.value = isValid;
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Handles the proceed button action
  /// Validates form and performs login logic
  Future<void> proceed() async {
    if (_context == null) return;

    if (!isFormValid.value) {
      _showValidationError();
      return;
    }

    isLoading.value = true;

    try {
      // Get phone number and password
      final phoneNumber = contactController.text.trim();
      final password = passwordController.text.trim();

      // Sign in using Firebase Auth
      final userId = await ServiceLocator.authService.signIn(
        phoneNumber: phoneNumber,
        password: password,
      );

      // Load user data from Firestore and save to user model
      await ServiceLocator.userController.loadUserData(userId);
      
      // Verify user data was loaded successfully
      if (ServiceLocator.userController.currentUser.value == null) {
        throw Exception('Failed to load user data. Please try again.');
      }

      // On success, show success message and navigate to home
      _showSuccessMessage('Login successful');
      
      // Navigate to home screen after successful login
      _context!.go(AppRoutes.home);
    } catch (e) {
      // Extract user-friendly error message
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showErrorMessage(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates to signup screen using go_router
  void navigateToSignUp() {
    if (_context != null) {
      _context!.go(AppRoutes.signup);
    }
  }

  /// Shows success message using ScaffoldMessenger
  void _showSuccessMessage(String message) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Shows error message using ScaffoldMessenger
  void _showErrorMessage(String message) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Shows validation error message
  void _showValidationError() {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes to prevent memory leaks
    contactController.dispose();
    passwordController.dispose();
    contactFocusNode.dispose();
    passwordFocusNode.dispose();
    _context = null;
    super.onClose();
  }
}
