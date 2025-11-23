import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../controllers/sheets_controller.dart';
import '../widgets/custom_button.dart';

/// Sheets screen - displays expense sheets and financial records
class SheetsScreen extends StatelessWidget {
  const SheetsScreen({super.key});

  /// Formats currency amount for display
  String _formatCurrency(double amount) {
    return '₹ ${NumberFormat('#,##0.00').format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final SheetsController controller = Get.put(SheetsController());
    controller.setContext(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title section
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.largeVerticalSpacing,
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: Text(
                  AppStrings.sheetsTab,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor,
                  ),
                ),
              ),

              // Sheets list
              Expanded(
                child: Obx(
                  () => controller.sheetsWithLastEntry.isEmpty
                      ? const Center(
                          child: Text(
                            'No sheets yet. Create one to get started!',
                            style: TextStyle(
                              color: AppColors.lightGreyColor,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.sheetsWithLastEntry.length,
                          itemBuilder: (context, index) {
                            final sheetWithEntry =
                                controller.sheetsWithLastEntry[index];
                            final sheet = sheetWithEntry.sheet;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Dismissible(
                                key: Key(sheet.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  controller.showDeleteSheetConfirmation(
                                    sheet.id,
                                    sheet.name,
                                  );
                                  return false; // Dialog handles deletion
                                },
                                child: _SheetListItem(
                                  sheetName: sheet.name,
                                  amount: _formatCurrency(sheet.totalAmount),
                                  lastEntryDate: sheetWithEntry.lastEntryDate,
                                  onTap: () {
                                    context.push(
                                      '${AppRoutes.home}/sheet/${sheet.id}',
                                      extra: sheet,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // Add Sheet button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: CustomButton(
                  text: AppStrings.addSheet,
                  isPrimary: true,
                  onPressed: controller.addSheet,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sheet list item widget
class _SheetListItem extends StatelessWidget {
  final String sheetName;
  final String amount;
  final DateTime? lastEntryDate;
  final VoidCallback onTap;

  const _SheetListItem({
    required this.sheetName,
    required this.amount,
    this.lastEntryDate,
    required this.onTap,
  });

  /// Formats date for display
  String _formatDate(DateTime? date) {
    if (date == null) return '';
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.blackColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sheetName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastEntryDate != null
                          ? '$amount | ${_formatDate(lastEntryDate)}'
                          : amount,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.mediumGreyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
