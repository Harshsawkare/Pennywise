import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/di/service_locator.dart';

/// SignUp controller managing the state and business logic for the signup screen
/// Follows GetX state management pattern and SOLID principles
class SignUpController extends GetxController {
  // Text editing controllers for form fields
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Focus nodes for managing field focus
  final FocusNode contactFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  // Observable state variables
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
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
    confirmPasswordController.addListener(validateForm);
  }

  /// Validates the entire form and updates isFormValid state
  /// Checks if all fields are filled, passwords match, and password length
  void validateForm() {
    final contact = contactController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final isValid = contact.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        password.length >= 6;

    isFormValid.value = isValid;
  }

  /// Toggles password visibility for password field
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggles password visibility for confirm password field
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Handles the proceed button action
  /// Validates form and performs signup logic
  Future<void> proceed() async {
    if (_context == null) return;

    if (!isFormValid.value) {
      _showValidationError();
      return;
    }

    // Validate password match
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorMessage('Passwords do not match');
      return;
    }

    isLoading.value = true;

    try {
      // Get phone number and password
      final phoneNumber = contactController.text.trim();
      final password = passwordController.text.trim();

      // Validate password length
      if (password.length < 6) {
        _showErrorMessage('Password must be at least 6 characters');
        isLoading.value = false;
        return;
      }

      // Sign up using Firebase Auth
      final userId = await ServiceLocator.authService.signUp(
        phoneNumber: phoneNumber,
        password: password,
      );

      // Load user data from Firestore (created during signup) and save to user model
      await ServiceLocator.userController.loadUserData(userId);
      
      // Verify user data was loaded successfully
      if (ServiceLocator.userController.currentUser.value == null) {
        throw Exception('Account created but failed to load user data. Please try logging in.');
      }

      // On success, show success message and navigate to home
      _showSuccessMessage('Account created successfully');
      
      // Navigate to home screen after successful signup
      _context!.go(AppRoutes.home);
    } catch (e) {
      // Extract user-friendly error message
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showErrorMessage(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates to login screen using go_router
  void navigateToLogin() {
    if (_context != null) {
      _context!.go(AppRoutes.login);
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
      debugPrint('| Error | $message');
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
          content: Text('Please fill all fields correctly'),
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
    confirmPasswordController.dispose();
    contactFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    _context = null;
    super.onClose();
  }
}
