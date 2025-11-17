import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing user data from Firestore
/// Follows clean architecture by keeping domain layer model simple
class UserModel {
  /// User's unique identifier
  final String uid;

  /// User's phone number
  final String phoneNo;

  /// Timestamp when user was created
  final DateTime createdOn;

  /// Timestamp when user was last updated
  final DateTime updateOn;

  /// Whether the user account is active
  final bool isActive;

  /// Selected currency code
  final String selectedCurrency;

  /// Whether to use 24-hour clock format
  final bool is24h;

  /// Whether EOD reminder is enabled
  final bool enableEODReminder;

  /// Constructor
  const UserModel({
    required this.uid,
    required this.phoneNo,
    required this.createdOn,
    required this.updateOn,
    required this.isActive,
    required this.selectedCurrency,
    required this.is24h,
    required this.enableEODReminder,
  });

  /// Creates UserModel from Firestore document snapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      uid: data['uid'] as String? ?? doc.id,
      phoneNo: data['phoneNo'] as String? ?? '',
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updateOn: (data['updateOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] as bool? ?? true,
      selectedCurrency: data['selectedCurrency'] as String? ?? 'INR',
      is24h: data['is24h'] as bool? ?? false,
      enableEODReminder: data['enableEODReminder'] as bool? ?? true,
    );
  }

  /// Creates UserModel from Firestore document data map
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      phoneNo: data['phoneNo'] as String? ?? '',
      createdOn: (data['createdOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updateOn: (data['updateOn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] as bool? ?? true,
      selectedCurrency: data['selectedCurrency'] as String? ?? 'INR',
      is24h: data['is24h'] as bool? ?? false,
      enableEODReminder: data['enableEODReminder'] as bool? ?? true,
    );
  }

  /// Converts UserModel to Firestore document map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNo': phoneNo,
      'createdOn': Timestamp.fromDate(createdOn),
      'updateOn': Timestamp.fromDate(updateOn),
      'isActive': isActive,
      'selectedCurrency': selectedCurrency,
      'is24h': is24h,
      'enableEODReminder': enableEODReminder,
    };
  }

  /// Creates a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? phoneNo,
    DateTime? createdOn,
    DateTime? updateOn,
    bool? isActive,
    String? selectedCurrency,
    bool? is24h,
    bool? enableEODReminder,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNo: phoneNo ?? this.phoneNo,
      createdOn: createdOn ?? this.createdOn,
      updateOn: updateOn ?? this.updateOn,
      isActive: isActive ?? this.isActive,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      is24h: is24h ?? this.is24h,
      enableEODReminder: enableEODReminder ?? this.enableEODReminder,
    );
  }
}

