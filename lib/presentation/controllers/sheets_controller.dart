import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../domain/models/sheet_model.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/service_locator.dart';

/// Sheets controller managing the state and business logic for the sheets screen
/// Follows GetX state management pattern and SOLID principles
class SheetsController extends GetxController {
  // BuildContext for navigation
  BuildContext? _context;

  /// List of sheets
  final RxList<SheetModel> sheets = <SheetModel>[].obs;

  /// Text controller for sheet name input
  final TextEditingController sheetNameController = TextEditingController();

  /// Sets the build context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    // Load sheets on initialization
    loadSheets();
  }

  @override
  void onClose() {
    sheetNameController.dispose();
    super.onClose();
  }

  /// Loads all sheets for the current user
  Future<void> loadSheets() async {
    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        sheets.value = [];
        return;
      }

      final loadedSheets = await ServiceLocator.sheetService.getSheets(userId);
      sheets.value = loadedSheets;
    } catch (e) {
      debugPrint('Failed to load sheets: $e');
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Failed to load sheets: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      sheets.value = [];
    }
  }

  /// Handles adding a new sheet
  /// Shows the add sheet dialog
  void addSheet() {
    if (_context == null) return;
    _showAddSheetDialog();
  }

  /// Shows the add sheet name dialog
  void _showAddSheetDialog() {
    if (_context == null) return;

    sheetNameController.clear();

    showDialog(
      context: _context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  AppStrings.addSheetName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // Input field
                TextField(
                  controller: sheetNameController,
                  decoration: InputDecoration(
                    hintText: AppStrings.sheetNamePlaceholder,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        AppStrings.cancel,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        if (sheetNameController.text.trim().isNotEmpty) {
                          _createSheet(sheetNameController.text.trim());
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        AppStrings.create,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates a new sheet
  Future<void> _createSheet(String name) async {
    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        if (_context != null) {
          ScaffoldMessenger.of(_context!).showSnackBar(
            const SnackBar(
              content: Text('User not authenticated'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final newSheet = await ServiceLocator.sheetService.createSheet(
        uid: userId,
        sheetName: name,
      );

      sheets.add(newSheet);

      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          const SnackBar(
            content: Text('Sheet created successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to create sheet: $e');
      if (_context != null) {
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Failed to create sheet: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

