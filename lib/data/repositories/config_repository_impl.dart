import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/config_repository.dart';

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

      if (data == null) {
        throw Exception('Config document data is null');
      }

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
}

