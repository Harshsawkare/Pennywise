import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Separator widget with "or" text between two horizontal lines
/// Matches the design specifications for separating action sections
class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.lightGreyColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.orSeparator,
            style: const TextStyle(
              color: AppColors.lightGreyColor,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.lightGreyColor,
          ),
        ),
      ],
    );
  }
}

