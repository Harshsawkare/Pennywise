import '../../domain/repositories/entry_repository.dart';
import '../../domain/models/entry_model.dart';
import '../../domain/repositories/sheet_repository.dart';

/// Service layer for entry operations
/// Acts as a use case layer between presentation and domain
class EntryService {
  final EntryRepository _entryRepository;
  final SheetRepository _sheetRepository;

  /// Constructor with dependency injection
  /// [entryRepository] - Entry repository instance
  /// [sheetRepository] - Sheet repository instance for updating totals
  EntryService(
    this._entryRepository,
    this._sheetRepository,
  );

  /// Calculates totals from entries and updates the sheet
  Future<void> _updateSheetTotals({
    required String uid,
    required String sheetId,
  }) async {
    try {
      final entries = await _entryRepository.getEntries(
        uid: uid,
        sheetId: sheetId,
      );

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (final entry in entries) {
        if (entry.type == 'income') {
          totalIncome += entry.amount;
        } else if (entry.type == 'expense') {
          totalExpense += entry.amount.abs();
        }
      }

      final totalAmount = totalIncome - totalExpense;

      await _sheetRepository.updateSheetTotals(
        uid: uid,
        sheetId: sheetId,
        totalAmount: totalAmount,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );
    } catch (e) {
      // Log error but don't throw - entry was created successfully
      // Totals can be recalculated later
      throw Exception('Failed to update sheet totals: ${e.toString()}');
    }
  }

  /// Creates a new entry
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [type] - Entry type ('expense' or 'income')
  /// [amount] - Entry amount
  /// [note] - Entry note/description
  /// [date] - Entry date
  /// [time] - Entry time (DateTime combining date and time)
  /// [category] - Entry category
  /// Returns the created EntryModel
  /// Throws [Exception] on failure
  Future<EntryModel> createEntry({
    required String uid,
    required String sheetId,
    required String type,
    required double amount,
    required String note,
    required DateTime date,
    required DateTime time,
    required String category,
  }) async {
    // Validation
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }
    if (type != 'expense' && type != 'income') {
      throw Exception('Entry type must be "expense" or "income"');
    }
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    // Create entry model
    final entry = EntryModel(
      id: '', // Will be set by repository
      amount: type == 'expense' ? -amount.abs() : amount.abs(),
      type: type,
      note: note.trim(),
      date: date,
      time: time,
      category: category,
      sheetId: sheetId,
      userId: uid,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );

    final createdEntry = await _entryRepository.createEntry(
      uid: uid,
      sheetId: sheetId,
      entry: entry,
    );

    // Update sheet totals after creating entry
    await _updateSheetTotals(uid: uid, sheetId: sheetId);

    return createdEntry;
  }

  /// Gets all entries for a sheet
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// Returns list of EntryModel
  /// Throws [Exception] on failure
  Future<List<EntryModel>> getEntries({
    required String uid,
    required String sheetId,
  }) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }

    return await _entryRepository.getEntries(
      uid: uid,
      sheetId: sheetId,
    );
  }

  /// Updates an existing entry and updates sheet totals
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [entryId] - Entry's unique identifier
  /// [type] - Entry type ('expense' or 'income')
  /// [amount] - Entry amount
  /// [note] - Entry note/description
  /// [date] - Entry date
  /// [time] - Entry time (DateTime combining date and time)
  /// [category] - Entry category
  /// Returns the updated EntryModel
  /// Throws [Exception] on failure
  Future<EntryModel> updateEntry({
    required String uid,
    required String sheetId,
    required String entryId,
    required String type,
    required double amount,
    required String note,
    required DateTime date,
    required DateTime time,
    required String category,
  }) async {
    // Validation
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }
    if (entryId.isEmpty) {
      throw Exception('Entry ID cannot be empty');
    }
    if (type != 'expense' && type != 'income') {
      throw Exception('Entry type must be "expense" or "income"');
    }
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    // Get existing entry to preserve createdOn
    final existingEntries = await _entryRepository.getEntries(
      uid: uid,
      sheetId: sheetId,
    );
    final existingEntry = existingEntries.firstWhere(
      (e) => e.id == entryId,
      orElse: () => throw Exception('Entry not found'),
    );

    // Create updated entry model
    final updatedEntry = existingEntry.copyWith(
      amount: type == 'expense' ? -amount.abs() : amount.abs(),
      type: type,
      note: note.trim(),
      date: date,
      time: time,
      category: category,
      updatedOn: DateTime.now(),
    );

    final result = await _entryRepository.updateEntry(
      uid: uid,
      sheetId: sheetId,
      entryId: entryId,
      entry: updatedEntry,
    );

    // Update sheet totals after updating entry
    await _updateSheetTotals(uid: uid, sheetId: sheetId);

    return result;
  }

  /// Deletes an entry and updates sheet totals
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [entryId] - Entry's unique identifier
  /// Throws [Exception] on failure
  Future<void> deleteEntry({
    required String uid,
    required String sheetId,
    required String entryId,
  }) async {
    if (uid.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (sheetId.isEmpty) {
      throw Exception('Sheet ID cannot be empty');
    }
    if (entryId.isEmpty) {
      throw Exception('Entry ID cannot be empty');
    }

    await _entryRepository.deleteEntry(
      uid: uid,
      sheetId: sheetId,
      entryId: entryId,
    );

    // Update sheet totals after deleting entry
    await _updateSheetTotals(uid: uid, sheetId: sheetId);
  }
}

