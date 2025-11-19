import 'package:get/get.dart';
import 'package:pennywise/core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';
import '../../core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/models/user_model.dart';

/// Settings controller managing the state and business logic for the settings screen
/// Follows GetX state management pattern and SOLID principles
class SettingsController extends GetxController {
  // Observable state variables for settings
  final RxBool is24hrClock = false.obs;
  final RxBool enableEODReminder = true.obs;
  final RxString selectedCurrency = 'INR'.obs;
  final RxList<String> currencies = <String>[].obs;
  final RxBool isLoadingCurrencies = false.obs;
  final RxBool isSaving = false.obs;

  // Original values to track changes
  String _originalCurrency = 'INR';
  bool _originalIs24hrClock = false;
  bool _originalEnableEODReminder = true;

  // Computed observable for unsaved changes
  bool get hasUnsavedChanges => selectedCurrency.value != _originalCurrency ||
      is24hrClock.value != _originalIs24hrClock ||
      enableEODReminder.value != _originalEnableEODReminder;

  // BuildContext for navigation
  BuildContext? _context;

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    // Load currencies from Firestore
    loadCurrencies();
    // Load user settings from user model
    loadUserSettings();
  }

  /// Loads user settings from user model
  void loadUserSettings() {
    final userController = ServiceLocator.userController;
    final currentUser = userController.currentUser.value;

    if (currentUser != null) {
      selectedCurrency.value = currentUser.selectedCurrency;
      is24hrClock.value = currentUser.is24h;
      enableEODReminder.value = currentUser.enableEODReminder;
      
      // Store original values to track changes
      _originalCurrency = currentUser.selectedCurrency;
      _originalIs24hrClock = currentUser.is24h;
      _originalEnableEODReminder = currentUser.enableEODReminder;
    }
  }


  /// Loads currencies from Firestore
  Future<void> loadCurrencies() async {
    isLoadingCurrencies.value = true;
    try {
      final currenciesList = await ServiceLocator.configService.getCurrencies();
      currencies.value = currenciesList;
    } catch (e) {
      // Show error message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Failed to load currencies: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      isLoadingCurrencies.value = false;
    }
  }

  /// Toggles 24-hour clock setting
  void toggle24hrClock(bool value) {
    is24hrClock.value = value;
  }

  /// Toggles EOD reminder setting
  void toggleEODReminder(bool value) {
    enableEODReminder.value = value;
  }

  /// Saves user settings to Firestore
  Future<void> saveSettings() async {
    if (_context == null) return;

    final userController = ServiceLocator.userController;
    final currentUser = userController.currentUser.value;

    if (currentUser == null) {
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('No user data found. Please log in again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    isSaving.value = true;

    try {
      // Create updated user model with new settings
      final updatedUser = currentUser.copyWith(
        selectedCurrency: selectedCurrency.value,
        is24h: is24hrClock.value,
        enableEODReminder: enableEODReminder.value,
        updateOn: DateTime.now(),
      );

      // Update user data in Firestore
      await userController.updateUserData(updatedUser);

      // Update original values after successful save
      _originalCurrency = selectedCurrency.value;
      _originalIs24hrClock = is24hrClock.value;
      _originalEnableEODReminder = enableEODReminder.value;

      // Show success message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Navigates to categories screen
  void navigateToCategories() {
    if (_context != null) {
      // TODO: Navigate to categories screen
      // _context!.go('/categories');
    }
  }

  /// Shows currency selection dialog
  void navigateToCurrency() {
    if (_context == null || currencies.isEmpty) {
      if (_context != null && currencies.isEmpty) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('No currencies available'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    showCurrencySelectionDialog();
  }

  /// Shows currency selection dialog with Cupertino-style scroll picker
  void showCurrencySelectionDialog() {
    if (_context == null) return;

    // Find the current selected index
    final currentIndex = currencies.indexOf(selectedCurrency.value);
    final selectedIndex = currentIndex >= 0 ? currentIndex : 0;

    showCupertinoModalPopup<void>(
      context: _context!,
      builder: (BuildContext context) {
        int tempSelectedIndex = selectedIndex;

        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius),
              topRight: Radius.circular(AppConstants.borderRadius),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Header with title and done button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                      const Material(
                        child: Text(
                          'Select Currency',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (tempSelectedIndex >= 0 &&
                              tempSelectedIndex < currencies.length) {
                            selectedCurrency.value =
                                currencies[tempSelectedIndex];
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scroll picker
                Expanded(
                  child: Obx(
                    () => CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedIndex,
                      ),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        tempSelectedIndex = index;
                      },
                      children: currencies.map((currency) {
                        return Center(
                          child: Text(
                            currency,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handles logout action
  /// Signs out the user and navigates to login screen
  Future<void> logout() async {
    if (_context == null) return;

    try {
      // Sign out using auth service
      await ServiceLocator.authService.signOut();

      // Clear user data from controller
      ServiceLocator.userController.clearUser();

      // Navigate to login screen
      _context!.go(AppRoutes.login);
    } catch (e) {
      // Show error message
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void onClose() {
    _context = null;
    super.onClose();
  }
}
