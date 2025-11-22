import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/add_edit_category_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/color_picker_widget.dart';
import '../../domain/models/category_model.dart';

/// Add/Edit Category screen for creating or editing categories
/// Supports both add and edit modes based on passed category
class AddEditCategoryScreen extends StatelessWidget {
  final CategoryModel? category;

  const AddEditCategoryScreen({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final AddEditCategoryController controller =
        Get.put(AddEditCategoryController());
    controller.setContext(context);
    controller.initialize(category);

    final isEditMode = category != null;
    final title = isEditMode ? AppStrings.editCategory : AppStrings.addCategories;
    final buttonText = isEditMode ? AppStrings.update : AppStrings.add;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.blackColor,
          ),
          onTap: () => context.pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Name input
              CustomTextField(
                placeholder: AppStrings.namePlaceholder,
                controller: controller.nameController,
              ),
              const SizedBox(height: AppConstants.verticalSpacing),
              // Hex code input
              CustomTextField(
                placeholder: AppStrings.hexCodePlaceholder,
                controller: controller.hexCodeController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  controller.onHexCodeChanged(value);
                },
              ),
              const SizedBox(height: 24),
              // Color picker
              Obx(
                () => ColorPickerWidget(
                  selectedColor: controller.selectedColor.value,
                  onColorChanged: (color) {
                    controller.updateColor(color);
                  },
                ),
              ),
              // Spacer to push button to bottom
              const Spacer(),
              // Add/Update button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: CustomButton(
                  text: buttonText,
                  isPrimary: true,
                  onPressed: () async {
                    try {
                      await controller.saveCategory();
                    } catch (e) {
                      // Error is already shown in the controller
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

