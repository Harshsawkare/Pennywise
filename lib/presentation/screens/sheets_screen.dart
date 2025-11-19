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
                  () => controller.sheets.isEmpty
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
                          itemCount: controller.sheets.length,
                          itemBuilder: (context, index) {
                            final sheet = controller.sheets[index];
                            return _SheetListItem(
                              sheetName: sheet.name,
                              amount: _formatCurrency(sheet.totalAmount),
                              onTap: () {
                                context.push(
                                  '${AppRoutes.home}/sheet/${sheet.id}',
                                  extra: sheet,
                                );
                              },
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
  final VoidCallback onTap;

  const _SheetListItem({
    required this.sheetName,
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.blackColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
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
                        amount,
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
      ),
    );
  }
}
