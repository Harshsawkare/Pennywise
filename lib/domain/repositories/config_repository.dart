import '../models/category_model.dart';

/// Domain layer repository interface for app configuration
/// Defines the contract for configuration operations following clean architecture
abstract class ConfigRepository {
  /// Fetches currencies array from Firestore
  /// Queries the config collection and retrieves currencies from the first document
  /// Returns list of currency strings
  /// Throws [Exception] on failure
  Future<List<String>> getCurrencies();

  /// Fetches default categories array from Firestore
  /// Queries config.defaultCategories.defaultCategories path
  /// Returns list of CategoryModel objects
  /// Throws [Exception] on failure
  Future<List<CategoryModel>> getDefaultCategories();
}

