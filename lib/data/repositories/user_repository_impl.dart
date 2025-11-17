import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';

/// Data layer implementation of UserRepository
/// Handles Firestore user data operations
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  /// Constructor with dependency injection
  /// [firestore] - Firebase Firestore instance (defaults to FirebaseFirestore.instance)
  UserRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final data = userDoc.data();
      if (data == null) {
        throw Exception('User document data is null');
      }

      return UserModel.fromMap(data, uid);
    } catch (e) {
      throw Exception('Failed to fetch user data: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }
}

