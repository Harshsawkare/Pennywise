import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Sheets screen - displays expense sheets and financial records
/// Placeholder screen for the Sheets tab functionality
class SheetsScreen extends StatelessWidget {
  const SheetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.sheetsTab,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blackColor,
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
            ],
          ),
        ),
      ),
    );
  }
}

