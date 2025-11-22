import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/service_locator.dart';
import '../../domain/models/category_model.dart';

/// Add Entry controller managing the state and business logic for the add entry screen
/// Follows GetX state management pattern and SOLID principles
class AddEntryController extends GetxController {
  // BuildContext for navigation
  BuildContext? _context;

  /// Sheet ID this entry belongs to (optional)
  String? sheetId;

  /// Entry type: 'expense' or 'income'
  final RxString entryType = 'expense'.obs;

  /// Amount controller
  final TextEditingController amountController = TextEditingController();

  /// Note controller
  final TextEditingController noteController = TextEditingController();

  /// Selected date
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// Selected time
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  /// Selected category
  final RxString selectedCategory = AppStrings.foodAndDrink.obs;

  /// Gets the list of categories from the current user
  /// Returns empty list if user is not loaded or has no categories
  List<CategoryModel> getCategories() {
    return ServiceLocator.userController.getCategories();
  }

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Sets the sheet ID for this entry
  void setSheetId(String? id) {
    sheetId = id;
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes to refresh categories
    final userController = ServiceLocator.userController;
    ever(userController.currentUser, (_) {
      // Force rebuild when categories are updated
      update();
    });
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  /// Toggles between expense and income
  void toggleEntryType(String type) {
    entryType.value = type;
  }

  /// Opens date picker
  Future<void> selectDate() async {
    if (_context == null) return;

    final DateTime? picked = await showDatePicker(
      context: _context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  /// Opens time picker
  Future<void> selectTime() async {
    if (_context == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: _context!,
      initialTime: selectedTime.value,
    );

    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  /// Formats date for display
  String getFormattedDate() {
    final months = [
      AppStrings.monthJan,
      AppStrings.monthFeb,
      AppStrings.monthMar,
      AppStrings.monthApr,
      AppStrings.monthMay,
      AppStrings.monthJun,
      AppStrings.monthJul,
      AppStrings.monthAug,
      AppStrings.monthSep,
      AppStrings.monthOct,
      AppStrings.monthNov,
      AppStrings.monthDec,
    ];
    final date = selectedDate.value;
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Formats time for display
  String getFormattedTime() {
    final time = selectedTime.value;
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? AppStrings.am : AppStrings.pm;
    return '$hour:$minute $period';
  }

  /// Handles adding the entry
  Future<void> addEntry() async {
    if (_context == null) return;

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.pleaseEnterValidAmount),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (sheetId == null || sheetId!.isEmpty) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.sheetIdMissing),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.userNotAuthenticated),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Combine date and time into DateTime
      final dateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );

      await ServiceLocator.entryService.createEntry(
        uid: userId,
        sheetId: sheetId!,
        type: entryType.value,
        amount: amount,
        note: noteController.text.trim(),
        date: selectedDate.value,
        time: dateTime,
        category: selectedCategory.value,
      );

      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.entryAddedSuccessfully),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back
      if (_context != null) {
        _context!.pop();
      }
    } catch (e) {
      debugPrint('Failed to create entry: $e');
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.failedToAddEntry}: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

