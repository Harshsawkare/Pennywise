import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Title widget for screens with optional teal accent dot
/// Matches the design specifications for screen headers
class ScreenTitle extends StatelessWidget {
  /// Main title text (first line)
  final String title;

  /// Subtitle text (second line)
  final String subtitle;

  /// Whether to show teal accent dot after subtitle
  final bool showAccentDot;

  const ScreenTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.showAccentDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (showAccentDot)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: AppColors.tealColor,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

