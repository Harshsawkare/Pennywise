import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/edit_entry_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/entry_model.dart';

/// Edit Entry screen for editing existing expense or income entries
class EditEntryScreen extends StatelessWidget {
  final EntryModel? entry;

  const EditEntryScreen({super.key, this.entry});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final EditEntryController controller = Get.put(EditEntryController());
    controller.setContext(context);
    
    // Initialize controller with entry data if provided
    // Always initialize to ensure we have the correct entry data
    if (entry != null) {
      controller.initialize(entry!);
    }

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
        title: const Text(
          AppStrings.editEntry,
          style: TextStyle(
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
              // Expense/Income toggle
              Obx(
                () => _ExpenseIncomeToggle(
                  selectedType: controller.entryType.value,
                  onTypeChanged: controller.toggleEntryType,
                ),
              ),

              const SizedBox(height: 24),

              // Amount input
              CustomTextField(
                placeholder: AppStrings.howMuch,
                controller: controller.amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              // Note input
              CustomTextField(
                placeholder: AppStrings.note,
                controller: controller.noteController,
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              // Date picker
              Obx(
                () => _DateTimePickerField(
                  label: AppStrings.date,
                  value: controller.getFormattedDate(),
                  onTap: controller.selectDate,
                ),
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              // Time picker
              Obx(
                () => _DateTimePickerField(
                  label: AppStrings.time,
                  value: controller.getFormattedTime(),
                  onTap: controller.selectTime,
                ),
              ),

              const SizedBox(height: AppConstants.verticalSpacing),

              // Category picker
              Obx(() {
                final categories = controller.getCategories();
                // Set default category if not set and categories are available
                if (categories.isNotEmpty &&
                    !categories.any(
                      (c) => c.name == controller.selectedCategory.value,
                    )) {
                  controller.selectedCategory.value = categories.first.name;
                }
                return _CategoryPicker(
                  selectedCategory: controller.selectedCategory.value,
                  categories: categories,
                  onCategoryChanged: (categoryName) {
                    controller.selectedCategory.value = categoryName;
                  },
                );
              }),

              // Spacer to push buttons to bottom
              const Spacer(),

              // Delete button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.verticalSpacing,
                ),
                child: CustomButton(
                  text: AppStrings.deleteEntry,
                  isPrimary: false,
                  onPressed: controller.showDeleteConfirmation,
                  borderColor: AppColors.redColor,
                  textColor: AppColors.redColor,
                ),
              ),

              // Update button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: CustomButton(
                  text: AppStrings.update,
                  isPrimary: true,
                  onPressed: controller.updateEntry,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Expense/Income toggle widget
class _ExpenseIncomeToggle extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const _ExpenseIncomeToggle({
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged('expense'),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedType == 'expense'
                      ? AppColors.lightGreyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.expense,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selectedType == 'expense'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged('income'),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedType == 'income'
                      ? AppColors.lightGreyColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.income,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selectedType == 'income'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date/Time picker field widget
class _DateTimePickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.inputFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.lightGreyColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category picker widget
class _CategoryPicker extends StatelessWidget {
  final String selectedCategory;
  final List<CategoryModel> categories;
  final Function(String) onCategoryChanged;

  const _CategoryPicker({
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  /// Converts hex color string to Color
  Color _hexToColor(String hexCode) {
    try {
      // Remove # if present
      final hex = hexCode.replaceAll('#', '');
      // Handle 6-digit hex
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      // Handle 8-digit hex (with alpha)
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      // Default to black if invalid
      return AppColors.blackColor;
    } catch (e) {
      return AppColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return Container(
              height: 400,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Header with title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            child: Text(
                              AppStrings.selectCategory,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.label,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Category list
                    Expanded(
                      child: categories.isEmpty
                          ? Center(
                              child: Text(
                                AppStrings.noCategoriesAvailable,
                                style: TextStyle(
                                  color: CupertinoColors.placeholderText,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final isSelected =
                                    selectedCategory == category.name;
                                return CupertinoListTile(
                                  leading: Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _hexToColor(category.hexCode),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                  title: Material(
                                    child: Text(
                                      category.name,
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(
                                          CupertinoIcons.check_mark,
                                          color: CupertinoColors.activeBlue,
                                        )
                                      : null,
                                  onTap: () {
                                    onCategoryChanged(category.name);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: AppConstants.inputFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.lightGreyColor, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCategory,
              style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.blackColor),
          ],
        ),
      ),
    );
  }
}

