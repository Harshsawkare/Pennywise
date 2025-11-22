import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../controllers/categories_controller.dart';
import '../widgets/custom_button.dart';
import '../../domain/models/category_model.dart';

/// Categories screen displaying list of user categories
/// Allows viewing, editing, and adding new categories
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  /// Converts hex color string to Color
  Color _hexToColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return AppColors.blackColor;
    } catch (e) {
      return AppColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final CategoriesController controller = Get.put(CategoriesController());

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
          AppStrings.categoriesTitle,
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
              const SizedBox(height: 24),
              // Categories list
              Expanded(
                child: Obx(
                  () {
                    final categories = controller.categories;
                    if (categories.isEmpty) {
                      return const Center(
                        child: Text(
                          AppStrings.noCategoriesYet,
                          style: TextStyle(
                            color: AppColors.mediumGreyColor,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isNoCategory = category.name == AppStrings.noCategory;
                        return _CategoryItem(
                          category: category,
                          color: _hexToColor(category.hexCode),
                          onEdit: isNoCategory ? null : () {
                            context.push(
                              '/home/edit-category',
                              extra: category,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Add Category button
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.largeVerticalSpacing,
                ),
                child: CustomButton(
                  text: AppStrings.addCategory,
                  isPrimary: true,
                  onPressed: () {
                    context.push('/home/add-category');
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

/// Category item widget displaying category name and color
class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final Color color;
  final VoidCallback? onEdit;

  const _CategoryItem({
    required this.category,
    required this.color,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.lightGreyColor,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Category name
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
              ),
            ),
          ),
          // Edit icon (only if not "No category")
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.lightGreyColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

