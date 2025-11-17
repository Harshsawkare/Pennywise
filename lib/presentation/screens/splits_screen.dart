import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Splits screen - displays expense splits and shared expenses
/// Placeholder screen for the Splits tab functionality
class SplitsScreen extends StatelessWidget {
  const SplitsScreen({super.key});

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
                AppStrings.splitsTab,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Splits content will be displayed here.',
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

