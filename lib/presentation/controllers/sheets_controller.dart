import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/models/sheet_model.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';
import '../../core/utils/snackbar_util.dart';

/// Helper class to store sheet with its last entry date
class SheetWithLastEntry {
  final SheetModel sheet;
  final DateTime? lastEntryDate;

  SheetWithLastEntry({
    required this.sheet,
    this.lastEntryDate,
  });
}

/// Sheets controller managing the state and business logic for the sheets screen
/// Follows GetX state management pattern and SOLID principles
class SheetsController extends GetxController {
  // BuildContext for navigation
  BuildContext? _context;

  /// List of sheets with last entry dates
  final RxList<SheetWithLastEntry> sheetsWithLastEntry = <SheetWithLastEntry>[].obs;

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

  /// Loads all sheets for the current user with last entry dates
  Future<void> loadSheets() async {
    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        sheetsWithLastEntry.value = [];
        return;
      }

      final loadedSheets = await ServiceLocator.sheetService.getSheets(userId);
      
      // Get last entry date for each sheet
      final List<SheetWithLastEntry> sheetsWithDates = [];
      for (final sheet in loadedSheets) {
        DateTime? lastEntryDate;
        try {
          final entries = await ServiceLocator.entryService.getEntries(
            uid: userId,
            sheetId: sheet.id,
          );
          if (entries.isNotEmpty) {
            // Sort by date descending and get the most recent
            entries.sort((a, b) => b.date.compareTo(a.date));
            lastEntryDate = entries.first.date;
          }
        } catch (e) {
          debugPrint('Failed to get entries for sheet ${sheet.id}: $e');
        }
        
        sheetsWithDates.add(SheetWithLastEntry(
          sheet: sheet,
          lastEntryDate: lastEntryDate,
        ));
      }
      
      // Sort by last entry date descending (most recent first)
      // Sheets without entries go to the end
      sheetsWithDates.sort((a, b) {
        if (a.lastEntryDate == null && b.lastEntryDate == null) {
          return b.sheet.updatedOn.compareTo(a.sheet.updatedOn);
        }
        if (a.lastEntryDate == null) return 1;
        if (b.lastEntryDate == null) return -1;
        return b.lastEntryDate!.compareTo(a.lastEntryDate!);
      });
      
      sheetsWithLastEntry.value = sheetsWithDates;
    } catch (e) {
      debugPrint('Failed to load sheets: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToLoadSheets}: ${e.toString()}',
      );
      sheetsWithLastEntry.value = [];
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

    showCupertinoModalPopup<void>(
      context: _context!,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius),
              topRight: Radius.circular(AppConstants.borderRadius),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Material(
                  child: Text(
                    AppStrings.addSheetName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Input field
                CupertinoTextField(
                  controller: sheetNameController,
                  placeholder: AppStrings.sheetNamePlaceholder,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.tertiarySystemFill,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      child: Text(
                        AppStrings.cancel,
                        style: const TextStyle(
                          color: CupertinoColors.secondaryLabel,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CupertinoButton(
                      onPressed: () {
                        if (sheetNameController.text.trim().isNotEmpty) {
                          _createSheet(sheetNameController.text.trim());
                          Navigator.of(context).pop();
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: const Text(
                        AppStrings.create,
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
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
        SnackbarUtil.show(_context, AppStrings.userNotAuthenticated);
        return;
      }

      await ServiceLocator.sheetService.createSheet(
        uid: userId,
        sheetName: name,
      );

      // Reload sheets to ensure proper sorting
      await loadSheets();

      SnackbarUtil.show(_context, AppStrings.sheetCreatedSuccessfully);
    } catch (e) {
      debugPrint('Failed to create sheet: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToCreateSheet}: ${e.toString()}',
      );
    }
  }

  /// Deletes a sheet
  /// [sheetId] - Sheet's unique identifier
  Future<void> deleteSheet(String sheetId) async {
    if (_context == null) return;

    try {
      final userId = ServiceLocator.authService.getCurrentUserId();
      if (userId == null) {
        SnackbarUtil.show(_context, AppStrings.userNotAuthenticated);
        return;
      }

      await ServiceLocator.sheetService.deleteSheet(
        uid: userId,
        sheetId: sheetId,
      );

      // Remove sheet from list
      sheetsWithLastEntry.removeWhere((item) => item.sheet.id == sheetId);

      SnackbarUtil.show(_context, AppStrings.sheetDeletedSuccessfully);
    } catch (e) {
      debugPrint('Failed to delete sheet: $e');
      SnackbarUtil.show(
        _context,
        '${AppStrings.failedToDeleteSheet}: ${e.toString()}',
      );
    }
  }

  /// Shows delete confirmation dialog for a sheet
  void showDeleteSheetConfirmation(String sheetId, String sheetName) {
    if (_context == null) return;

    showCupertinoDialog<void>(
      context: _context!,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppStrings.deleteSheet),
          content: Text(AppStrings.deleteSheetConfirmation),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancel,
                style: const TextStyle(
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                deleteSheet(sheetId);
              },
              child: Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
  }
}
