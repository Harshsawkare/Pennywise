import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/models/sheet_model.dart';
import '../../domain/models/entry_model.dart';
import '../../domain/models/category_model.dart';
import '../controllers/sheet_entries_controller.dart';
import '../../core/di/service_locator.dart';
import '../widgets/custom_button.dart';

/// Sheet Entries screen - displays all entries for a specific sheet
class SheetEntriesScreen extends StatelessWidget {
  final SheetModel sheet;

  const SheetEntriesScreen({super.key, required this.sheet});

  /// Formats currency amount for display
  String _formatCurrency(double amount) {
    return '₹ ${NumberFormat('#,##0.00').format(amount.abs())}';
  }

  /// Formats currency with sign
  String _formatCurrencyWithSign(double amount) {
    final sign = amount >= 0 ? '+' : '-';
    return '$sign ${_formatCurrency(amount)}';
  }

  /// Gets relative date string (Today, Yesterday, or day name)
  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateOnly == today) {
      return AppStrings.today;
    } else if (dateOnly == yesterday) {
      return AppStrings.yesterday;
    } else {
      return DateFormat('EEE').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final SheetEntriesController controller = Get.put(SheetEntriesController());
    controller.setContext(context);
    controller.initialize(sheet);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.blackColor,
          ),
          onTap: () => context.pop(),
        ),
        title: Text(
          sheet.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.horizontalPadding),
            child: Obx(
              () => GestureDetector(
                onTap: controller.showCategoryFilter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    controller.categoryFilterText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Financial summary section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Balance
                    Text(
                      _formatCurrency(controller.totalBalance),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Expenses and Income
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatCurrencyWithSign(-controller.totalExpenses),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGreyColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '|',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGreyColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatCurrencyWithSign(controller.totalIncome),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGreyColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Entries list
            Expanded(
              child: Obx(() {
                final entriesByDate = controller.entriesByDate;

                if (entriesByDate.isEmpty) {
                  return const Center(
                    child: Text(
                      AppStrings.noEntriesYet,
                      style: TextStyle(
                        color: AppColors.lightGreyColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalPadding,
                  ),
                  itemCount: entriesByDate.length,
                  itemBuilder: (context, index) {
                    final date = entriesByDate.keys.elementAt(index);
                    final dayEntries = entriesByDate[date]!;
                    final dailyTotal = controller.getDailyTotal(dayEntries);

                    return _DateGroup(
                      date: date,
                      relativeDate: _getRelativeDate(date),
                      entries: dayEntries,
                      dailyTotal: dailyTotal,
                      formatCurrency: _formatCurrency,
                      formatCurrencyWithSign: _formatCurrencyWithSign,
                    );
                  },
                );
              }),
            ),

            // Add Entry button
            Padding(
              padding: const EdgeInsets.all(AppConstants.horizontalPadding),
              child: CustomButton(
                text: AppStrings.addEntry,
                isPrimary: true,
                onPressed: controller.navigateToAddEntry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Date group widget showing entries for a specific date
class _DateGroup extends StatelessWidget {
  final DateTime date;
  final String relativeDate;
  final List<EntryModel> entries;
  final double dailyTotal;
  final String Function(double) formatCurrency;
  final String Function(double) formatCurrencyWithSign;

  const _DateGroup({
    required this.date,
    required this.relativeDate,
    required this.entries,
    required this.dailyTotal,
    required this.formatCurrency,
    required this.formatCurrencyWithSign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                _formatDateHeader(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                relativeDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mediumGreyColor,
                ),
              ),
              const Spacer(),
              Text(
                formatCurrencyWithSign(dailyTotal),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: dailyTotal >= 0
                      ? AppColors.greenColor
                      : AppColors.mediumGreyColor,
                ),
              ),
            ],
          ),
        ),

        // Entry cards
        ...entries.map(
          (entry) => _EntryCard(
            entry: entry,
            formatCurrency: formatCurrency,
            formatCurrencyWithSign: formatCurrencyWithSign,
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  String _formatDateHeader(DateTime date) {
    final day = date.day;
    String suffix = AppStrings.dateSuffixTh;
    if (day == 1 || day == 21 || day == 31) {
      suffix = AppStrings.dateSuffixSt;
    } else if (day == 2 || day == 22) {
      suffix = AppStrings.dateSuffixNd;
    } else if (day == 3 || day == 23) {
      suffix = AppStrings.dateSuffixRd;
    }
    return DateFormat('d\'$suffix\' MMM').format(date);
  }
}

/// Helper function to convert hex color string to Color
Color _hexToColor(String hexCode) {
  try {
    final hex = hexCode.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    return AppColors.blackColor;
  } catch (e) {
    return AppColors.blackColor;
  }
}

/// Entry card widget
class _EntryCard extends StatelessWidget {
  final EntryModel entry;
  final String Function(double) formatCurrency;
  final String Function(double) formatCurrencyWithSign;

  const _EntryCard({
    required this.entry,
    required this.formatCurrency,
    required this.formatCurrencyWithSign,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.type == 'income';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColors.lightGreyColor.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Colored vertical line - reactive to category updates
          Obx(() {
            final userController = ServiceLocator.userController;
            final currentUser = userController.currentUser.value;
            final categories = currentUser?.categories ?? [];
            final categoryModel = categories.firstWhere(
              (c) => c.name == entry.category,
              orElse: () => CategoryModel(
                name: entry.category,
                hexCode: '#E0E0E0',
              ),
            );
            final color = _hexToColor(categoryModel.hexCode);
            return Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
            );
          }),
          const SizedBox(width: 12),
          // Entry details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ),
                  if (entry.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGreyColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Amount
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              formatCurrencyWithSign(entry.amount),
              style: TextStyle(
                fontSize: 16,
                color: isIncome ? AppColors.greenColor : AppColors.mediumGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
