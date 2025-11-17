/// Domain layer repository interface for app configuration
/// Defines the contract for configuration operations following clean architecture
abstract class ConfigRepository {
  /// Fetches currencies array from Firestore
  /// Queries the config collection and retrieves currencies from the first document
  /// Returns list of currency strings
  /// Throws [Exception] on failure
  Future<List<String>> getCurrencies();
}

