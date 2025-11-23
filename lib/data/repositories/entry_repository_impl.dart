import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/entry_repository.dart';
import '../../domain/models/entry_model.dart';

/// Data layer implementation of EntryRepository
/// Handles Firestore entry data operations
class EntryRepositoryImpl implements EntryRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  /// Constructor with dependency injection
  /// [firestore] - Firebase Firestore instance (defaults to FirebaseFirestore.instance)
  /// [uuid] - UUID generator instance (defaults to Uuid())
  EntryRepositoryImpl({
    FirebaseFirestore? firestore,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  @override
  Future<EntryModel> createEntry({
    required String uid,
    required String sheetId,
    required EntryModel entry,
  }) async {
    try {
      final entryId = _uuid.v4();
      final now = DateTime.now();

      // Combine date and time into a single DateTime for storage
      final dateTime = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
        entry.time.hour,
        entry.time.minute,
      );

      final entryData = {
        'id': entryId,
        'createdOn': Timestamp.fromDate(now),
        'type': entry.type,
        'amount': entry.amount,
        'note': entry.note,
        'date': Timestamp.fromDate(entry.date),
        'time': Timestamp.fromDate(dateTime),
        'category': entry.category,
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .collection('entries')
          .doc(entryId)
          .set(entryData);

      return entry.copyWith(
        id: entryId,
        createdOn: now,
        updatedOn: now,
        sheetId: sheetId,
        userId: uid,
      );
    } catch (e) {
      throw Exception('Failed to create entry: ${e.toString()}');
    }
  }

  @override
  Future<List<EntryModel>> getEntries({
    required String uid,
    required String sheetId,
  }) async {
    try {
      final entriesSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .collection('entries')
          .orderBy('createdOn', descending: true)
          .get();

      final entries = <EntryModel>[];

      for (final doc in entriesSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
        final time = (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();

        final entry = EntryModel(
          id: data['id'] as String? ?? doc.id,
          amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
          type: data['type'] as String? ?? 'expense',
          note: data['note'] as String? ?? '',
          date: date,
          time: time,
          category: data['category'] as String? ?? '',
          sheetId: sheetId,
          userId: uid,
          createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
        entries.add(entry);
      }

      return entries;
    } catch (e) {
      throw Exception('Failed to fetch entries: ${e.toString()}');
    }
  }

  @override
  Future<EntryModel> updateEntry({
    required String uid,
    required String sheetId,
    required String entryId,
    required EntryModel entry,
  }) async {
    try {
      final now = DateTime.now();

      // Combine date and time into a single DateTime for storage
      final dateTime = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
        entry.time.hour,
        entry.time.minute,
      );

      final entryData = {
        'type': entry.type,
        'amount': entry.amount,
        'note': entry.note,
        'date': Timestamp.fromDate(entry.date),
        'time': Timestamp.fromDate(dateTime),
        'category': entry.category,
        'updatedOn': Timestamp.fromDate(now),
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .collection('entries')
          .doc(entryId)
          .update(entryData);

      return entry.copyWith(
        id: entryId,
        updatedOn: now,
        sheetId: sheetId,
        userId: uid,
      );
    } catch (e) {
      throw Exception('Failed to update entry: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEntry({
    required String uid,
    required String sheetId,
    required String entryId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .collection('entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete entry: ${e.toString()}');
    }
  }
}

