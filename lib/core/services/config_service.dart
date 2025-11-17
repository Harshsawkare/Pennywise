import '../../domain/repositories/config_repository.dart';

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
}

