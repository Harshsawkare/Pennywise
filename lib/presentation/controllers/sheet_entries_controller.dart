import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/sheet_model.dart';
import '../../domain/models/entry_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/di/service_locator.dart';

/// Sheet Entries controller managing the state and business logic for sheet entries screen
/// Follows GetX state management pattern and SOLID principles
class SheetEntriesController extends GetxController {
  // BuildContext for navigation
  BuildContext? _context;

  /// Current sheet being viewed
  final Rx<SheetModel?> currentSheet = Rx<SheetModel?>(null);

  /// List of entries for the current sheet
  final RxList<EntryModel> entries = <EntryModel>[].obs;

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
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
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Failed to load entries: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      entries.value = [];
    }
  }

  /// Calculates total balance (income - expenses)
  double get totalBalance {
    return entries.fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Calculates total expenses
  double get totalExpenses {
    return entries
        .where((entry) => entry.type == 'expense')
        .fold(0.0, (sum, entry) => sum + entry.amount.abs());
  }

  /// Calculates total income
  double get totalIncome {
    return entries
        .where((entry) => entry.type == 'income')
        .fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Groups entries by date
  Map<DateTime, List<EntryModel>> get entriesByDate {
    final Map<DateTime, List<EntryModel>> grouped = {};
    
    for (final entry in entries) {
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
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
    );

    return sortedEntries;
  }

  /// Gets daily total for a list of entries
  double getDailyTotal(List<EntryModel> dayEntries) {
    return dayEntries.fold(0.0, (sum, entry) => sum + entry.amount);
  }

  /// Gets category color
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food and Drink':
        return AppColors.blueColor;
      case 'Fun and Entertainment':
        return AppColors.orangeColor;
      case 'Budget':
        return AppColors.greenColor;
      default:
        return AppColors.blueColor;
    }
  }

  /// Navigates to add entry screen
  void navigateToAddEntry() {
    if (_context == null || currentSheet.value == null) return;

    _context!.push(
      '${AppRoutes.home}/add-entry?sheetId=${currentSheet.value!.id}',
    ).then((_) {
      // Reload entries and sheet after returning from add entry screen
      loadEntries();
      _reloadSheet();
    });
  }

  /// Reloads the current sheet to get updated totals
  Future<void> _reloadSheet() async {
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
    // TODO: Implement category filter
    ScaffoldMessenger.of(_context!).showSnackBar(
      const SnackBar(
        content: Text('Category filter coming soon'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

