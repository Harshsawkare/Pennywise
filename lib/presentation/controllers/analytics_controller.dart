import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/entry_model.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/user_tier.dart';
import '../../core/services/entry_service.dart';
import '../../core/services/sheet_service.dart';
import '../../core/di/service_locator.dart';

/// Category analytics data model
class CategoryAnalytics {
  final String category;
  final double amount;
  final double percentage;
  final String hexCode;

  CategoryAnalytics({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.hexCode,
  });
}

/// Analytics controller managing analytics data and calculations
/// Follows GetX state management pattern and SOLID principles
class AnalyticsController extends GetxController {
  final EntryService _entryService;
  final SheetService _sheetService;

  /// Selected time period: 0 for Week, 1 for Month
  final RxInt selectedPeriod = 0.obs;

  /// Total income amount
  final RxDouble totalIncome = 0.0.obs;

  /// Total expense amount
  final RxDouble totalExpense = 0.0.obs;

  /// Total balance (income - expense)
  final RxDouble totalBalance = 0.0.obs;

  /// List of expense categories with analytics
  final RxList<CategoryAnalytics> expenseCategories = <CategoryAnalytics>[].obs;

  /// List of income categories with analytics
  final RxList<CategoryAnalytics> incomeCategories = <CategoryAnalytics>[].obs;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Constructor with dependency injection
  /// [entryService] - Entry service instance (defaults to ServiceLocator)
  /// [sheetService] - Sheet service instance (defaults to ServiceLocator)
  AnalyticsController({EntryService? entryService, SheetService? sheetService})
    : _entryService = entryService ?? ServiceLocator.entryService,
      _sheetService = sheetService ?? ServiceLocator.sheetService;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  /// Changes the selected time period
  /// [period] - 0 for Week, 1 for Month
  void changePeriod(int period) {
    selectedPeriod.value = period;
    loadAnalytics();
  }

  /// Loads analytics data for the selected time period
  Future<void> loadAnalytics() async {
    try {
      isLoading.value = true;

      // Check if user has premium tier
      final userController = ServiceLocator.userController;
      final tier = userController.getTier();

      if (tier == UserTier.freemium) {
        // Don't load analytics data for freemium users
        _resetAnalytics();
        isLoading.value = false;
        return;
      }

      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        _resetAnalytics();
        return;
      }

      // Get all sheets for the user
      final sheets = await _sheetService.getSheets(userId);
      if (sheets.isEmpty) {
        _resetAnalytics();
        return;
      }

      // Get all entries from all sheets
      List<EntryModel> allEntries = [];
      for (final sheet in sheets) {
        try {
          final entries = await _entryService.getEntries(
            uid: userId,
            sheetId: sheet.id,
          );
          allEntries.addAll(entries);
        } catch (e) {
          debugPrint('Failed to load entries for sheet ${sheet.id}: $e');
        }
      }

      // Filter entries by time period
      final filteredEntries = _filterEntriesByPeriod(allEntries);

      // Calculate analytics
      _calculateAnalytics(filteredEntries, userId);
    } catch (e) {
      debugPrint('Failed to load analytics: $e');
      _resetAnalytics();
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters entries based on selected time period
  List<EntryModel> _filterEntriesByPeriod(List<EntryModel> entries) {
    final now = DateTime.now();
    DateTime startDate;

    if (selectedPeriod.value == 0) {
      // Week: last 7 days
      startDate = now.subtract(const Duration(days: 7));
    } else {
      // Month: current month
      startDate = DateTime(now.year, now.month, 1);
    }

    return entries.where((entry) {
      final entryDate = entry.date;
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  /// Calculates analytics from filtered entries
  void _calculateAnalytics(List<EntryModel> entries, String userId) {
    // Get user categories for hex codes
    final userController = ServiceLocator.userController;
    final userCategories = userController.currentUser.value?.categories ?? [];

    // Calculate totals
    double income = 0.0;
    double expense = 0.0;

    // Group by category
    final Map<String, double> expenseCategoryMap = {};
    final Map<String, double> incomeCategoryMap = {};

    for (final entry in entries) {
      if (entry.type == 'income') {
        income += entry.amount.abs();
        incomeCategoryMap[entry.category] =
            (incomeCategoryMap[entry.category] ?? 0.0) + entry.amount.abs();
      } else if (entry.type == 'expense') {
        expense += entry.amount.abs();
        expenseCategoryMap[entry.category] =
            (expenseCategoryMap[entry.category] ?? 0.0) + entry.amount.abs();
      }
    }

    // Update totals
    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;

    // Calculate category analytics for expenses
    final expenseCategoryList = expenseCategoryMap.entries.map((entry) {
      final categoryName = entry.key.isEmpty ? 'Uncategorized' : entry.key;
      final categoryModel = userCategories.firstWhere(
        (cat) => cat.name == entry.key,
        orElse: () => const CategoryModel(name: '', hexCode: '#9E9E9E'),
      );
      return CategoryAnalytics(
        category: categoryName,
        amount: entry.value,
        percentage: expense > 0 ? (entry.value / expense) * 100 : 0.0,
        hexCode: categoryModel.hexCode,
      );
    }).toList();

    // Sort by amount descending and take top 3
    expenseCategoryList.sort((a, b) => b.amount.compareTo(a.amount));
    expenseCategories.value = expenseCategoryList.take(3).toList();

    // Calculate category analytics for income
    final incomeCategoryList = incomeCategoryMap.entries.map((entry) {
      final categoryName = entry.key.isEmpty ? 'Uncategorized' : entry.key;
      final categoryModel = userCategories.firstWhere(
        (cat) => cat.name == entry.key,
        orElse: () => const CategoryModel(name: '', hexCode: '#9E9E9E'),
      );
      return CategoryAnalytics(
        category: categoryName,
        amount: entry.value,
        percentage: income > 0 ? (entry.value / income) * 100 : 0.0,
        hexCode: categoryModel.hexCode,
      );
    }).toList();

    // Sort by amount descending and take top 3
    incomeCategoryList.sort((a, b) => b.amount.compareTo(a.amount));
    incomeCategories.value = incomeCategoryList.take(3).toList();
  }

  /// Resets analytics to default values
  void _resetAnalytics() {
    totalIncome.value = 0.0;
    totalExpense.value = 0.0;
    totalBalance.value = 0.0;
    expenseCategories.value = [];
    incomeCategories.value = [];
  }
}
