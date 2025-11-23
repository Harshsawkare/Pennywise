import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/sheet_repository.dart';
import '../../domain/models/sheet_model.dart';

/// Data layer implementation of SheetRepository
/// Handles Firestore sheet data operations
class SheetRepositoryImpl implements SheetRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  /// Constructor with dependency injection
  /// [firestore] - Firebase Firestore instance (defaults to FirebaseFirestore.instance)
  /// [uuid] - UUID generator instance (defaults to Uuid())
  SheetRepositoryImpl({
    FirebaseFirestore? firestore,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  @override
  Future<SheetModel> createSheet({
    required String uid,
    required String sheetName,
  }) async {
    try {
      final sheetId = _uuid.v4();
      final now = DateTime.now();

      final sheetData = {
        'id': sheetId,
        'name': sheetName,
        'totalAmount': 0.0,
        'totalIncome': 0.0,
        'totalExpense': 0.0,
        'createdOn': Timestamp.fromDate(now),
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .set(sheetData);

      return SheetModel(
        id: sheetId,
        name: sheetName,
        totalAmount: 0.0,
        totalIncome: 0.0,
        totalExpense: 0.0,
        createdOn: now,
        updatedOn: now,
        userId: uid,
      );
    } catch (e) {
      throw Exception('Failed to create sheet: ${e.toString()}');
    }
  }

  @override
  Future<List<SheetModel>> getSheets(String uid) async {
    try {
      final sheetsSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .get();

      final sheets = <SheetModel>[];

      for (final doc in sheetsSnapshot.docs) {
        final data = doc.data();
        final sheet = SheetModel(
          id: data['id'] as String? ?? doc.id,
          name: data['name'] as String? ?? '',
          totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
          totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
          totalExpense: (data['totalExpense'] as num?)?.toDouble() ?? 0.0,
          createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
          userId: uid,
        );
        sheets.add(sheet);
      }

      return sheets;
    } catch (e) {
      throw Exception('Failed to fetch sheets: ${e.toString()}');
    }
  }

  @override
  Future<SheetModel> getSheetById({
    required String uid,
    required String sheetId,
  }) async {
    try {
      final sheetDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .get();

      if (!sheetDoc.exists) {
        throw Exception('Sheet document not found');
      }

      final data = sheetDoc.data();
      if (data == null) {
        throw Exception('Sheet document data is null');
      }

      return SheetModel(
        id: data['id'] as String? ?? sheetId,
        name: data['name'] as String? ?? '',
        totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
        totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
        totalExpense: (data['totalExpense'] as num?)?.toDouble() ?? 0.0,
        createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
        userId: uid,
      );
    } catch (e) {
      throw Exception('Failed to fetch sheet: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSheetTotals({
    required String uid,
    required String sheetId,
    required double totalAmount,
    required double totalIncome,
    required double totalExpense,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .update({
        'totalAmount': totalAmount,
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'updatedOn': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update sheet totals: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSheet({
    required String uid,
    required String sheetId,
  }) async {
    try {
      // Delete all entries in the sheet first
      final entriesSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sheets')
          .doc(sheetId)
          .collection('entries')
          .get();

      final batch = _firestore.batch();
      for (final doc in entriesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the sheet document
      batch.delete(
        _firestore
            .collection('users')
            .doc(uid)
            .collection('sheets')
            .doc(sheetId),
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete sheet: ${e.toString()}');
    }
  }
}

