import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_item.dart';
import '../widgets/custom_button.dart';

/// Settings screen - displays app settings and user preferences
/// Matches the design specifications with categories, currency, toggles, and logout
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final SettingsController controller = Get.put(SettingsController());
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
              // Title section with save icon
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.largeVerticalSpacing,
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.settingsTab,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Obx(
                      () => controller.hasUnsavedChanges
                          ? GestureDetector(
                              onTap: controller.isSaving.value
                                  ? null
                                  : controller.saveSettings,
                              child: controller.isSaving.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.lightGreyColor,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.save_rounded,
                                      color: AppColors.lightGreyColor,
                                      size: 24,
                                    ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // Settings items
              SettingsItem(
                title: AppStrings.categories,
                onTap: controller.navigateToCategories,
                showArrow: true,
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              Obx(
                () => SettingsItem(
                  title: AppStrings.currency,
                  badge: controller.selectedCurrency.value,
                  onTap: controller.navigateToCurrency,
                  showArrow: false,
                ),
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              Obx(
                () => SettingsItem(
                  title: AppStrings.use24hrClock,
                  subtitle: AppStrings.use24hrClockSubtitle,
                  showToggle: true,
                  toggleValue: controller.is24hrClock.value,
                  onToggleChanged: controller.toggle24hrClock,
                  showArrow: false,
                ),
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              Obx(
                () => SettingsItem(
                  title: AppStrings.eodReminder,
                  subtitle: AppStrings.eodReminderSubtitle,
                  showToggle: true,
                  toggleValue: controller.enableEODReminder.value,
                  onToggleChanged: controller.toggleEODReminder,
                  showArrow: false,
                ),
              ),

              // Spacer to push logout button to bottom
              const Spacer(),

              // Logout button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: CustomButton(
                  text: AppStrings.logout,
                  isPrimary: true,
                  onPressed: controller.logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
