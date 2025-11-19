import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/or_separator.dart';
import '../widgets/app_footer.dart';
import '../widgets/screen_title.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';

/// Login screen matching the design specifications
/// Displays form for logging in with contact and password fields
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final LoginController controller = Get.put(LoginController());
    // Set context for navigation and snackbars
    controller.setContext(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ) +
              EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title section
              Padding(
                padding: const EdgeInsets.only(
                  top: AppConstants.largeVerticalSpacing,
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: ScreenTitle(
                  title: AppStrings.loginTitle,
                  subtitle: AppStrings.loginSubtitle,
                  showAccentDot: true,
                ),
              ),

              // Input fields section
              CustomTextField(
                placeholder: AppStrings.contactPlaceholder,
                controller: controller.contactController,
                focusNode: controller.contactFocusNode,
                onChanged: (_) => controller.validateForm(),
                onSubmitted: (_) {
                  controller.contactFocusNode.unfocus();
                  controller.passwordFocusNode.requestFocus();
                },
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              Obx(
                () => CustomTextField(
                  placeholder: AppStrings.passwordPlaceholder,
                  isPassword: true,
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocusNode,
                  showPasswordToggle: true,
                  isPasswordVisible: controller.isPasswordVisible.value,
                  onTogglePasswordVisibility:
                      controller.togglePasswordVisibility,
                  onChanged: (_) => controller.validateForm(),
                  onSubmitted: (_) {
                    controller.passwordFocusNode.unfocus();
                    controller.proceed();
                  },
                ),
              ),

              const SizedBox(height: AppConstants.largeVerticalSpacing),

              // Proceed button
              Obx(
                () => CustomButton(
                  text: AppStrings.proceedButton,
                  isPrimary: true,
                  isEnabled:
                      controller.isFormValid.value &&
                      !controller.isLoading.value,
                  onPressed: controller.proceed,
                ),
              ),

              const SizedBox(height: AppConstants.largeVerticalSpacing),

              // Or separator
              const OrSeparator(),

              const SizedBox(height: AppConstants.largeVerticalSpacing),

              // Create account button
              CustomButton(
                text: AppStrings.createAccountButton,
                isPrimary: false,
                onPressed: controller.navigateToSignUp,
              ),

              // Spacer to push footer to bottom
              const Spacer(),

              // Footer
              const Padding(
                padding: EdgeInsets.only(bottom: AppConstants.verticalSpacing),
                child: AppFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
