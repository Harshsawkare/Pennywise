import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Footer widget displaying the app name
/// Matches the design specifications with centered light grey text
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.appNameLowerCase,
        style: const TextStyle(
          color: AppColors.lightGreyColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

