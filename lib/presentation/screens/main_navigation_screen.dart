import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import 'sheets_screen.dart';
import 'splits_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Main navigation screen with bottom navigation bar
/// Displays 4 tabs: Sheets, Splits, Analytics, and Settings
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller for tab management
    final MainNavigationController controller =
        Get.put(MainNavigationController());

    // List of screens corresponding to each tab
    final List<Widget> screens = [
      const SheetsScreen(),
      const SplitsScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];

    // List of tab labels
    final List<String> tabLabels = [
      AppStrings.sheetsTab,
      AppStrings.splitsTab,
      AppStrings.analyticsTab,
      AppStrings.settingsTab,
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.blackColor,
          unselectedItemColor: AppColors.lightGreyColor,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          items: List.generate(
            tabLabels.length,
            (index) => BottomNavigationBarItem(
              icon: const SizedBox.shrink(),
              label: tabLabels[index],
            ),
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

