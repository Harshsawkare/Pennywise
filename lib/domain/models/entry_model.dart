import 'package:cloud_firestore/cloud_firestore.dart';

/// Entry model representing a single expense or income entry
class EntryModel {
  /// Entry's unique identifier
  final String id;

  /// Amount of the entry (positive for income, negative for expense)
  final double amount;

  /// Entry type: 'expense' or 'income'
  final String type;

  /// Note/description for the entry
  final String note;

  /// Date of the entry
  final DateTime date;

  /// Time of the entry
  final DateTime time;

  /// Category of the entry (e.g., "Food and Drink", "Fun and Entertainment")
  final String category;

  /// Sheet ID this entry belongs to
  final String sheetId;

  /// User ID who created this entry
  final String userId;

  /// Timestamp when entry was created
  final DateTime createdOn;

  /// Timestamp when entry was last updated
  final DateTime updatedOn;

  /// Constructor
  const EntryModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
    required this.time,
    required this.category,
    required this.sheetId,
    required this.userId,
    required this.createdOn,
    required this.updatedOn,
  });

  /// Creates EntryModel from Firestore document snapshot
  factory EntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EntryModel(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      type: data['type'] as String? ?? 'expense',
      note: data['note'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] as String? ?? '',
      sheetId: data['sheetId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Creates EntryModel from Firestore document data map
  factory EntryModel.fromMap(Map<String, dynamic> data, String id) {
    return EntryModel(
      id: id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      type: data['type'] as String? ?? 'expense',
      note: data['note'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] as String? ?? '',
      sheetId: data['sheetId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts EntryModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'note': note,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
      'category': category,
      'sheetId': sheetId,
      'userId': userId,
      'createdOn': Timestamp.fromDate(createdOn),
      'updatedOn': Timestamp.fromDate(updatedOn),
    };
  }

  /// Creates a copy of EntryModel with updated fields
  EntryModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? note,
    DateTime? date,
    DateTime? time,
    String? category,
    String? sheetId,
    String? userId,
    DateTime? createdOn,
    DateTime? updatedOn,
  }) {
    return EntryModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      sheetId: sheetId ?? this.sheetId,
      userId: userId ?? this.userId,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }
}

