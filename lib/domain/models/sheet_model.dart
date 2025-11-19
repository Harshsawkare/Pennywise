import 'package:cloud_firestore/cloud_firestore.dart';

/// Sheet model representing an expense sheet
/// A sheet is a collection of entries for a specific period or purpose
class SheetModel {
  /// Sheet's unique identifier
  final String id;

  /// Sheet name (e.g., "Nov 2025", "Ooty Trip")
  final String name;

  /// Total amount in the sheet (income - expenses)
  final double totalAmount;

  /// Total income in the sheet
  final double totalIncome;

  /// Total expenses in the sheet
  final double totalExpense;

  /// Timestamp when sheet was created
  final DateTime createdOn;

  /// Timestamp when sheet was last updated
  final DateTime updatedOn;

  /// User ID who owns this sheet
  final String userId;

  /// Constructor
  const SheetModel({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.totalIncome,
    required this.totalExpense,
    required this.createdOn,
    required this.updatedOn,
    required this.userId,
  });

  /// Creates SheetModel from Firestore document snapshot
  factory SheetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SheetModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (data['totalExpense'] as num?)?.toDouble() ?? 0.0,
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] as String? ?? '',
    );
  }

  /// Creates SheetModel from Firestore document data map
  factory SheetModel.fromMap(Map<String, dynamic> data, String id) {
    return SheetModel(
      id: id,
      name: data['name'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (data['totalExpense'] as num?)?.toDouble() ?? 0.0,
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedOn: (data['updatedOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] as String? ?? '',
    );
  }

  /// Converts SheetModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalAmount': totalAmount,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'createdOn': Timestamp.fromDate(createdOn),
      'updatedOn': Timestamp.fromDate(updatedOn),
      'userId': userId,
    };
  }

  /// Creates a copy of SheetModel with updated fields
  SheetModel copyWith({
    String? id,
    String? name,
    double? totalAmount,
    double? totalIncome,
    double? totalExpense,
    DateTime? createdOn,
    DateTime? updatedOn,
    String? userId,
  }) {
    return SheetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      userId: userId ?? this.userId,
    );
  }
}

