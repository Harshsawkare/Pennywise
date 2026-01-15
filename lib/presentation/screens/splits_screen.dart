import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title section
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.largeVerticalSpacing,
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: Text(
                  AppStrings.splitsTab,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor,
                  ),
                ),
              ),

              // Coming Soon UI
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: BoxBorder.all(width: 3)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.call_split_rounded,
                            size: 30,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Coming Soon Title
                      Text(
                        AppStrings.comingSoon,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subtitle
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          AppStrings.comingSoonMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGreyColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
