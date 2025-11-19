import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Reusable settings item widget
/// Displays a setting option with optional subtitle, badge, toggle, or arrow
class SettingsItem extends StatelessWidget {
  /// Main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional badge text (e.g., currency code)
  final String? badge;

  /// Whether to show a toggle switch
  final bool showToggle;

  /// Toggle switch value (only used if showToggle is true)
  final bool? toggleValue;

  /// Callback when toggle is changed (only used if showToggle is true)
  final ValueChanged<bool>? onToggleChanged;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Whether to show navigation arrow
  final bool showArrow;

  const SettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.showToggle = false,
    this.toggleValue,
    this.onToggleChanged,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: AppColors.blackColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Left side - Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.lightGreyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Right side - Badge, toggle, or arrow
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],

            if (showToggle) ...[
              Switch(
                value: toggleValue ?? false,
                onChanged: onToggleChanged,
                activeColor: AppColors.tealColor,
                inactiveThumbColor: AppColors.whiteColor,
                inactiveTrackColor: AppColors.lightGreyColor,
              ),
            ],

            if (showArrow && !showToggle) ...[
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.lightGreyColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

