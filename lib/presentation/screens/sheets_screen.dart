import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/sheets_controller.dart';
import '../widgets/custom_button.dart';

/// Sheets screen - displays expense sheets and financial records
/// Placeholder screen for the Sheets tab functionality
class SheetsScreen extends StatelessWidget {
  const SheetsScreen({super.key});

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
              const SizedBox(height: 16),
              const Text(
                'Sheets content will be displayed here.',
                style: TextStyle(
                  color: AppColors.lightGreyColor,
                  fontSize: 16,
                ),
              ),

              // Spacer to push add sheet button to bottom
              const Spacer(),

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

