import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Custom text field widget matching the design specifications
/// Reusable component for consistent input styling across the app
class CustomTextField extends StatelessWidget {
  /// Placeholder text displayed when field is empty
  final String placeholder;

  /// Whether this field is for password input
  final bool isPassword;

  /// Controller for managing text input
  final TextEditingController? controller;

  /// Focus node for managing focus state
  final FocusNode? focusNode;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Whether to show password visibility toggle
  final bool showPasswordToggle;

  /// Whether password is currently visible
  final bool isPasswordVisible;

  /// Callback to toggle password visibility
  final VoidCallback? onTogglePasswordVisibility;

  const CustomTextField({
    super.key,
    required this.placeholder,
    this.isPassword = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.showPasswordToggle = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.inputFieldHeight,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.lightGreyColor,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: AppColors.lightGreyColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: showPasswordToggle
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.lightGreyColor,
                    size: 20,
                  ),
                  onPressed: onTogglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}

