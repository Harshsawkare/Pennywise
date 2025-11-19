import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/add_entry_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

/// Add Entry screen for creating new expense or income entries
class AddEntryScreen extends StatelessWidget {
  final String? sheetId;

  const AddEntryScreen({super.key, this.sheetId});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final AddEntryController controller = Get.put(AddEntryController());
    controller.setContext(context);
    if (sheetId != null) {
      controller.setSheetId(sheetId);
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
          AppStrings.newEntry,
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
            Obx(
              () => _CategoryPicker(
                selectedCategory: controller.selectedCategory.value,
                onCategoryChanged: (category) {
                  controller.selectedCategory.value = category;
                },
              ),
            ),

            // Spacer to push button to bottom
            const Spacer(),

            // Add button
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppConstants.largeVerticalSpacing,
              ),
              child: CustomButton(
                text: AppStrings.add,
                isPrimary: true,
                onPressed: controller.addEntry,
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
  final Function(String) onCategoryChanged;

  const _CategoryPicker({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      AppStrings.foodAndDrink,
      'Fun and Entertainment',
      'Budget',
      'Transport',
      'Shopping',
      'Bills',
    ];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Category',
                    style: TextStyle(color: AppColors.mediumGreyColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...categories.map((category) {
                    return ListTile(
                      title: Text(category),
                      trailing: selectedCategory == category
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        onCategoryChanged(category);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
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
