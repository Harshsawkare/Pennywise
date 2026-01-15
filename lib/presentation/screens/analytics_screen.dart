import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';
import '../../domain/models/user_tier.dart';
import '../controllers/analytics_controller.dart';

/// Analytics screen - displays financial analytics and insights
/// Shows income, expenses, balance, and category breakdowns
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  /// Formats currency amount for display
  String _formatCurrency(double amount) {
    final userController = ServiceLocator.userController;
    final currency = userController.getSelectedCurrency();
    final symbol = currency == 'INR' ? '₹' : '\$';
    return '$symbol ${NumberFormat('#,##0.00').format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final AnalyticsController controller = Get.put(AnalyticsController());
    final userController = ServiceLocator.userController;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
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
                      AppStrings.analyticsTab,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  // Segment Control for Week/Month
                  Obx(() => _buildSegmentControl(controller)),
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ListView(
                              shrinkWrap: true,
                              children: [
                                const SizedBox(
                                  height: AppConstants.verticalSpacing,
                                ),

                                // Summary Cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.trending_up,
                                        label: AppStrings.income,
                                        amount: controller.totalIncome.value,
                                        color: AppColors.greenColor,
                                        backgroundColor:
                                            AppColors.lightGreenColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.trending_down,
                                        label: AppStrings.expense,
                                        amount: controller.totalExpense.value,
                                        color: AppColors.redColor,
                                        backgroundColor:
                                            AppColors.lightRedColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: AppConstants.verticalSpacing,
                                ),

                                // Total Balance Card
                                _buildTotalBalanceCard(controller),

                                const SizedBox(
                                  height: AppConstants.largeVerticalSpacing,
                                ),

                                // Expenses by Category
                                if (controller
                                    .expenseCategories
                                    .isNotEmpty) ...[
                                  Material(
                                    child: Text(
                                      AppStrings.expensesByCategory,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mediumGreyColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppConstants.verticalSpacing,
                                  ),
                                  ...controller.expenseCategories.map(
                                    (category) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildCategoryItem(
                                        category: category,
                                        totalAmount:
                                            controller.totalExpense.value,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppConstants.largeVerticalSpacing,
                                  ),
                                ],

                                // Income by Category
                                if (controller.incomeCategories.isNotEmpty) ...[
                                  Material(
                                    child: Text(
                                      AppStrings.incomeByCategory,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mediumGreyColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppConstants.verticalSpacing,
                                  ),
                                  ...controller.incomeCategories.map(
                                    (category) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildCategoryItem(
                                        category: category,
                                        totalAmount:
                                            controller.totalIncome.value,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            // Blur overlay for freemium users
            Obx(() {
              final user = userController.currentUser.value;
              final isFreemium =
                  (user?.tier ?? UserTier.freemium) == UserTier.freemium;
              if (!isFreemium) return const SizedBox.shrink();

              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: AppColors.whiteColor.withValues(alpha: 0.3),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalPadding,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: BoxBorder.all(width: 3)
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                size: 40,
                                color: AppColors.blackColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                AppStrings.analyticsPremiumMessage,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.mediumGreyColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to premium upgrade screen
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blackColor,
                                foregroundColor: AppColors.whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  AppStrings.getPremium,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds the segment control for Week/Month selection
  Widget _buildSegmentControl(AnalyticsController controller) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changePeriod(0),
              child: Container(
                decoration: BoxDecoration(
                  color: controller.selectedPeriod.value == 0
                      ? AppColors.lightGreyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.week,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: controller.selectedPeriod.value == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.changePeriod(1),
              child: Container(
                decoration: BoxDecoration(
                  color: controller.selectedPeriod.value == 1
                      ? AppColors.lightGreyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.month,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: controller.selectedPeriod.value == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a summary card (Income or Expense)
  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.blackColor),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the total balance card with gradient
  Widget _buildTotalBalanceCard(AnalyticsController controller) {
    final balance = controller.totalBalance.value;
    final isPositive = balance >= 0;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.tealStartColor, AppColors.tealEndColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.totalBalance,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mediumGreyColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tealStartColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${_formatCurrency(balance)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _formatCurrency(balance),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.tealColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a category item with progress bar
  Widget _buildCategoryItem({
    required CategoryAnalytics category,
    required double totalAmount,
  }) {
    // Parse category color from hexCode
    final categoryColor = Color(
      int.parse(category.hexCode.replaceFirst('#', '0xFF')),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${category.percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumGreyColor,
                        ),
                      ),
                      Text(
                        _formatCurrency(category.amount),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: category.percentage / 100,
            minHeight: 6,
            backgroundColor: AppColors.lightGreyColor.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
          ),
        ),
      ],
    );
  }
}
