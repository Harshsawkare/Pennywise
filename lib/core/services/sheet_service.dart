import '../../domain/repositories/sheet_repository.dart';
import '../../domain/models/sheet_model.dart';

/// Service layer for sheet operations
/// Acts as a use case layer between presentation and domain
class SheetService {
  final SheetRepository _sheetRepository;

  /// Constructor with dependency injection
  /// [sheetRepository] - Sheet repository instance
  SheetService(this._sheetRepository);

  /// Creates a new sheet
  /// [uid] - User's unique identifier
  /// [sheetName] - Name of the sheet
  /// Returns the created SheetModel
  /// Throws [Exception] on failure
  Future<SheetModel> createSheet({
    required String uid,
    required String sheetName,
  }) async {
    // Validation
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetName.trim().isEmpty) {
      throw Exception('Sheet name cannot be empty');
    }

    return await _sheetRepository.createSheet(
      uid: uid,
      sheetName: sheetName.trim(),
    );
  }

  /// Gets all sheets for a user
  /// [uid] - User's unique identifier
  /// Returns list of SheetModel
  /// Throws [Exception] on failure
  Future<List<SheetModel>> getSheets(String uid) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    return await _sheetRepository.getSheets(uid);
  }

  /// Gets a single sheet by ID
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// Returns SheetModel
  /// Throws [Exception] on failure
  Future<SheetModel> getSheetById({
    required String uid,
    required String sheetId,
  }) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }

    return await _sheetRepository.getSheetById(
      uid: uid,
      sheetId: sheetId,
    );
  }

  /// Updates sheet totals
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
  }) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }

    return await _sheetRepository.updateSheetTotals(
      uid: uid,
      sheetId: sheetId,
      totalAmount: totalAmount,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
  }

  /// Deletes a sheet and all its entries
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// Throws [Exception] on failure
  Future<void> deleteSheet({
    required String uid,
    required String sheetId,
  }) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }

    return await _sheetRepository.deleteSheet(
      uid: uid,
      sheetId: sheetId,
    );
  }
}

