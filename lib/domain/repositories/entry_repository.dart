import '../models/entry_model.dart';

/// Domain layer repository interface for entry data operations
/// Defines the contract for entry data operations following clean architecture
abstract class EntryRepository {
  /// Creates a new entry in Firestore
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [entry] - EntryModel to create
  /// Returns the created EntryModel
  /// Throws [Exception] on failure
  Future<EntryModel> createEntry({
    required String uid,
    required String sheetId,
    required EntryModel entry,
  });

  /// Fetches all entries for a sheet from Firestore
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// Returns list of EntryModel on success
  /// Throws [Exception] on failure
  Future<List<EntryModel>> getEntries({
    required String uid,
    required String sheetId,
  });

  /// Updates an existing entry in Firestore
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [entryId] - Entry's unique identifier
  /// [entry] - EntryModel with updated data
  /// Returns the updated EntryModel
  /// Throws [Exception] on failure
  Future<EntryModel> updateEntry({
    required String uid,
    required String sheetId,
    required String entryId,
    required EntryModel entry,
  });

  /// Deletes an entry from Firestore
  /// [uid] - User's unique identifier
  /// [sheetId] - Sheet's unique identifier
  /// [entryId] - Entry's unique identifier
  /// Throws [Exception] on failure
  Future<void> deleteEntry({
    required String uid,
    required String sheetId,
    required String entryId,
  });
}

