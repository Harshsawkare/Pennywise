import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/sheet_model.dart';
import '../../domain/models/entry_model.dart';
import '../../domain/models/category_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/di/service_locator.dart';
import '../../core/utils/snackbar_util.dart';

/// Sheet Entries controller managing the state and business logic for sheet entries screen
/// Follows GetX state management pattern and SOLID principles
class SheetEntriesController extends GetxController {
  // BuildContext for navigation
  BuildContext? _context;

  /// Current sheet being viewed
  final Rx<SheetModel?> currentSheet = Rx<SheetModel?>(null);

  /// List of entries for the current sheet
  final RxList<EntryModel> entries = <EntryModel>[].obs;

  /// Selected category filter (null means "All categories")
  final Rx<String?> selectedCategoryFilter = Rx<String?>(null);

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes to refresh category colors
    final userController = ServiceLocator.userController;
    ever(userController.currentUser, (_) {
      // Force rebuild when categories are updated
      update();
    });
  }

  /// Initializes the controller with a sheet
  void initialize(SheetModel sheet) {
    currentSheet.value = sheet;
    loadEntries();
  }

  /// Loads all entries for the current sheet
  Future<void> loadEntries() async {
    if (currentSheet.value == null) return;

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        entries.value = [];
        return;
      }

      final loadedEntries = await ServiceLocator.entryService.getEntries(
        uid: userId,
        sheetId: currentSheet.value!.id,
      );
      entries.value = loadedEntries;
    } catch (e) {
      debugPrint('Failed to load entries: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToLoadEntries}: ${e.toString()}',
      );
      entries.value = [];
    }
  }

  /// Calculates total balance (income - expenses) for filtered entries
  double get totalBalance {
    return filteredEntries.fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Calculates total expenses for filtered entries
  double get totalExpenses {
    return filteredEntries
        .where((entry) => entry.type == 'expense')
        .fold(0.0, (sum, entry) => sum + entry.amount.abs());
  }

  /// Calculates total income for filtered entries
  double get totalIncome {
    return filteredEntries
        .where((entry) => entry.type == 'income')
        .fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Gets filtered entries based on selected category
  List<EntryModel> get filteredEntries {
    final filter = selectedCategoryFilter.value;
    if (filter == null || filter.isEmpty) {
      return entries;
    }
    return entries.where((entry) => entry.category == filter).toList();
  }

  /// Groups entries by date (respects category filter)
  Map<DateTime, List<EntryModel>> get entriesByDate {
    final Map<DateTime, List<EntryModel>> grouped = {};
    final filtered = filteredEntries;

    for (final entry in filtered) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(entry);
    }

    // Sort entries within each date by time
    for (final date in grouped.keys) {
      grouped[date]!.sort((a, b) => b.time.compareTo(a.time));
    }

    // Sort dates in descending order
    final sortedEntries = Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    return sortedEntries;
  }

  /// Gets daily total for a list of entries
  double getDailyTotal(List<EntryModel> dayEntries) {
    return dayEntries.fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Gets category color from hex code stored in user's categories
  /// Looks up the category by name and returns its hexCode color
  /// Returns lightGreyColor as default if category not found
  Color getCategoryColor(String category) {
    final categories = ServiceLocator.userController.getCategories();
    final categoryModel = categories.firstWhere(
      (c) => c.name == category,
      orElse: () => CategoryModel(
        name: category,
        hexCode: '#E0E0E0',
      ), // Default to light grey
    );
    return _hexToColor(categoryModel.hexCode);
  }

  /// Converts hex color string to Color
  Color _hexToColor(String hexCode) {
    try {
      // Remove # if present
      final hex = hexCode.replaceAll('#', '');
      // Handle 6-digit hex
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      // Handle 8-digit hex (with alpha)
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      // Default to black if invalid
      return AppColors.blackColor;
    } catch (e) {
      return AppColors.blackColor;
    }
  }

  /// Gets the display text for the category filter button
  String get categoryFilterText {
    final filter = selectedCategoryFilter.value;
    if (filter == null || filter.isEmpty) {
      return AppStrings.allCategories;
    }
    return filter;
  }

  /// Navigates to add entry screen
  void navigateToAddEntry() {
    if (_context == null || currentSheet.value == null) return;

      _context!
        .push('${AppRoutes.home}/add-entry?sheetId=${currentSheet.value!.id}')
        .then((_) {
          // Reload entries and sheet after returning from add entry screen
          loadEntries();
          reloadSheet();
        });
  }

  /// Reloads the current sheet to get updated totals
  Future<void> reloadSheet() async {
    if (currentSheet.value == null) return;

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) return;

      final updatedSheet = await ServiceLocator.sheetService.getSheetById(
        uid: userId,
        sheetId: currentSheet.value!.id,
      );
      currentSheet.value = updatedSheet;
    } catch (e) {
      debugPrint('Failed to reload sheet: $e');
    }
  }

  /// Handles category filter button
  void showCategoryFilter() {
    if (_context == null) return;

    final categories = ServiceLocator.userController.getCategories();

    showCupertinoModalPopup<void>(
      context: _context!,
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Header with title
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.separator,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        child: Text(
                          AppStrings.selectCategory,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Category list
                Expanded(
                  child: ListView(
                    children: [
                      // All Categories option
                      Obx(
                        () => CupertinoListTile(
                          leading: Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                          title: Material(
                            child: Text(
                              AppStrings.allCategories,
                              style: TextStyle(color: AppColors.blackColor),
                            ),
                          ),
                          trailing:
                              selectedCategoryFilter.value == null ||
                                  selectedCategoryFilter.value?.isEmpty == true
                              ? const Icon(
                                  CupertinoIcons.check_mark,
                                  color: CupertinoColors.activeBlue,
                                )
                              : null,
                          onTap: () {
                            selectedCategoryFilter.value = null;
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Category options
                      if (categories.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              AppStrings.noCategoriesAvailable,
                              style: TextStyle(
                                color: CupertinoColors.placeholderText,
                              ),
                            ),
                          ),
                        )
                      else
                        ...categories.map((category) {
                          return Obx(() {
                            final isSelected =
                                selectedCategoryFilter.value == category.name;
                            return CupertinoListTile(
                              leading: Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _hexToColor(category.hexCode),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                              title: Material(
                                child: Text(
                                  category.name,
                                  style: TextStyle(color: AppColors.blackColor),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      CupertinoIcons.check_mark,
                                      color: CupertinoColors.activeBlue,
                                    )
                                  : null,
                              onTap: () {
                                selectedCategoryFilter.value = category.name;
                                Navigator.pop(context);
                              },
                            );
                          });
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Deletes an entry
  /// [entryId] - Entry's unique identifier
  Future<void> deleteEntry(String entryId) async {
    if (_context == null || currentSheet.value == null) return;

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        SnackbarUtil.show(_context, AppStrings.userNotAuthenticated);
        return;
      }

      await ServiceLocator.entryService.deleteEntry(
        uid: userId,
        sheetId: currentSheet.value!.id,
        entryId: entryId,
      );

      // Remove entry from list
      entries.removeWhere((entry) => entry.id == entryId);

      // Reload sheet to update totals
      await reloadSheet();

      SnackbarUtil.show(_context, AppStrings.entryDeletedSuccessfully);
    } catch (e) {
      debugPrint('Failed to delete entry: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToDeleteEntry}: ${e.toString()}',
      );
    }
  }

  /// Shows delete confirmation dialog for an entry
  void showDeleteEntryConfirmation(String entryId) {
    if (_context == null) return;

    showCupertinoDialog<void>(
      context: _context!,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppStrings.deleteEntry),
          content: Text(AppStrings.deleteEntryConfirmation),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancel,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                deleteEntry(entryId);
              },
              child: Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }
}
