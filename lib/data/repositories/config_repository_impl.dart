import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/config_repository.dart';
import '../../domain/models/category_model.dart';

/// Data layer implementation of ConfigRepository
/// Handles Firestore configuration operations
/// Queries config collection without knowing the document ID
class ConfigRepositoryImpl implements ConfigRepository {
  final FirebaseFirestore _firestore;

  /// Constructor with dependency injection
  /// [firestore] - Firebase Firestore instance (defaults to FirebaseFirestore.instance)
  ConfigRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<String>> getCurrencies() async {
    try {
      // Query config collection to get all documents
      final configQuerySnapshot = await _firestore
          .collection('config')
          .limit(1)
          .get();

      if (configQuerySnapshot.docs.isEmpty) {
        throw Exception('No config documents found');
      }

      // Get the first document (assuming there's at least one config document)
      final configDoc = configQuerySnapshot.docs.first;
      final data = configDoc.data();

      final currencies = data['currencies'];
      if (currencies == null) {
        return []; // Return empty list if currencies field doesn't exist
      }

      if (currencies is! List) {
        throw Exception('Currencies field is not an array');
      }

      // Convert list to List<String>
      return currencies.map((e) => e.toString()).toList();
    } catch (e) {
      throw Exception('Failed to fetch currencies: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getDefaultCategories() async {
    try {
      // Query config collection to get defaultCategories document
      final defaultCategoriesDoc = await _firestore
          .collection('config')
          .doc('defaultCategories')
          .get();

      if (!defaultCategoriesDoc.exists) {
        throw Exception('Default categories document not found');
      }

      final data = defaultCategoriesDoc.data();
      if (data == null) {
        throw Exception('Default categories document data is null');
      }

      final defaultCategories = data['defaultCategories'];
      if (defaultCategories == null) {
        return []; // Return empty list if defaultCategories field doesn't exist
      }

      if (defaultCategories is! List) {
        throw Exception('Default categories field is not an array');
      }

      // Convert list of maps to List<CategoryModel>
      return defaultCategories
          .map((e) {
            if (e is Map<String, dynamic>) {
              return CategoryModel.fromMap(e);
            }
            return null;
          })
          .whereType<CategoryModel>()
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch default categories: ${e.toString()}');
    }
  }
}

