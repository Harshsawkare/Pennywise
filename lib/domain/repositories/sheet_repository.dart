import '../models/sheet_model.dart';

/// Domain layer repository interface for sheet data operations
/// Defines the contract for sheet data operations following clean architecture
abstract class SheetRepository {
  /// Creates a new sheet in Firestore
  /// [uid] - User's unique identifier
  /// [sheetName] - Name of the sheet
  /// Returns the created SheetModel
  /// Throws [Exception] on failure
  Future<SheetModel> createSheet({
    required String uid,
    required String sheetName,
  });

  /// Fetches all sheets for a user from Firestore
  /// [uid] - User's unique identifier
  /// Returns list of SheetModel on success
  /// Throws [Exception] on failure
  Future<List<SheetModel>> getSheets(String uid);

  /// Fetches a single sheet by ID
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// Returns SheetModel on success
  /// Throws [Exception] on failure
  Future<SheetModel> getSheetById({
    required String uid,
    required String sheetId,
  });

  /// Updates sheet totals (totalAmount, totalIncome, totalExpense)
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [totalAmount] - New total amount
  /// [totalIncome] - New total income
  /// [totalExpense] - New total expense
  /// Throws [Exception] on failure
  Future<void> updateSheetTotals({
    required String uid,
    required String sheetId,
    required double totalAmount,
    required double totalIncome,
    required double totalExpense,
  });
}

