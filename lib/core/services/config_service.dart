import '../../domain/repositories/config_repository.dart';
import '../../domain/models/category_model.dart';

/// Service layer for configuration operations
/// Acts as a use case layer between presentation and domain
class ConfigService {
  final ConfigRepository _configRepository;

  /// Constructor with dependency injection
  /// [configRepository] - Configuration repository instance
  ConfigService(this._configRepository);

  /// Fetches currencies from Firestore
  /// Queries config collection and retrieves currencies from the first document
  /// Returns list of currency strings
  /// Throws [Exception] on failure
  Future<List<String>> getCurrencies() async {
    return await _configRepository.getCurrencies();
  }

  /// Fetches default categories from Firestore
  /// Queries config.defaultCategories.defaultCategories path
  /// Returns list of CategoryModel objects
  /// Throws [Exception] on failure
  Future<List<CategoryModel>> getDefaultCategories() async {
    return await _configRepository.getDefaultCategories();
  }
}

