import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';
import '../../domain/models/category_model.dart';
import '../../core/utils/snackbar_util.dart';

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
    // Reset fields when controller is initialized
    resetFields();
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

    await showCupertinoModalPopup<void>(
      context: _context!,
      builder: (BuildContext context) {
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
                // Header with done button
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
                        child: Text(
                          AppStrings.cancel,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                      Material(
                        child: Text(
                          AppStrings.date,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppStrings.done,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate.value,
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime(2100),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime newDate) {
                      selectedDate.value = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Opens time picker
  Future<void> selectTime() async {
    if (_context == null) return;

    // Get user's 24-hour clock preference
    final use24hFormat = ServiceLocator.userController.getIs24h();

    DateTime tempDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    await showCupertinoModalPopup<void>(
      context: _context!,
      builder: (BuildContext context) {
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
                // Header with done button
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
                        child: Text(
                          AppStrings.cancel,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                      Material(
                        child: Text(
                          AppStrings.time,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          selectedTime.value = TimeOfDay(
                            hour: tempDateTime.hour,
                            minute: tempDateTime.minute,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppStrings.done,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: tempDateTime,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: use24hFormat,
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempDateTime = newDateTime;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
  /// Respects user's 24-hour clock preference
  String getFormattedTime() {
    final time = selectedTime.value;
    final use24hFormat = ServiceLocator.userController.getIs24h();
    
    if (use24hFormat) {
      // 24-hour format: HH:mm
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      // 12-hour format: h:mm AM/PM
      final hour = time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? AppStrings.am : AppStrings.pm;
      return '$hour:$minute $period';
    }
  }

  /// Resets all form fields to default values
  void resetFields() {
    amountController.clear();
    noteController.clear();
    entryType.value = 'expense';
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
    // Set default category if categories are available
    final categories = getCategories();
    if (categories.isNotEmpty) {
      selectedCategory.value = categories.first.name;
    } else {
      selectedCategory.value = AppStrings.foodAndDrink;
    }
  }

  /// Handles adding the entry
  Future<void> addEntry() async {
    if (_context == null) return;

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      SnackbarUtil.show(_context, AppStrings.pleaseEnterValidAmount);
      return;
    }

    if (sheetId == null || sheetId!.isEmpty) {
      SnackbarUtil.show(_context, AppStrings.sheetIdMissing);
      return;
    }

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        SnackbarUtil.show(_context, AppStrings.userNotAuthenticated);
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

      SnackbarUtil.show(_context, AppStrings.entryAddedSuccessfully);

      // Reset fields after successful save
      resetFields();

      // Navigate back
      if (_context != null) {
        _context!.pop();
      }
    } catch (e) {
      debugPrint('Failed to create entry: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToAddEntry}: ${e.toString()}',
      );
    }
  }
}
