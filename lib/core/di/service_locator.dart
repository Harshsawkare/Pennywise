import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/config_repository.dart';
import '../../data/repositories/config_repository_impl.dart';
import '../services/config_service.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../services/user_service.dart';
import '../controllers/user_controller.dart';

/// Dependency injection service locator
/// Centralizes object creation and dependency management
class ServiceLocator {
  // Private constructor to prevent instantiation
  ServiceLocator._();

  // Singleton instances
  static AuthRepository? _authRepository;
  static AuthService? _authService;
  static ConfigRepository? _configRepository;
  static ConfigService? _configService;
  static UserRepository? _userRepository;
  static UserService? _userService;
  static UserController? _userController;

  /// Initializes all services and repositories
  /// Should be called once at app startup
  static void init() {
    // Initialize repositories
    _authRepository = AuthRepositoryImpl();
    _configRepository = ConfigRepositoryImpl();
    _userRepository = UserRepositoryImpl();
    
    // Initialize services
    _authService = AuthService(_authRepository!);
    _configService = ConfigService(_configRepository!);
    _userService = UserService(_userRepository!);
    
    // Initialize controllers (pass service directly to avoid getter access during init)
    _userController = UserController(userService: _userService!);
  }

  /// Gets the authentication repository instance
  static AuthRepository get authRepository {
    if (_authRepository == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _authRepository!;
  }

  /// Gets the authentication service instance
  static AuthService get authService {
    if (_authService == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _authService!;
  }

  /// Gets the configuration service instance
  static ConfigService get configService {
    if (_configService == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _configService!;
  }

  /// Gets the user service instance
  static UserService get userService {
    if (_userService == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _userService!;
  }

  /// Gets the user controller instance
  static UserController get userController {
    if (_userController == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _userController!;
  }

  /// Resets all services (useful for testing)
  static void reset() {
    _authRepository = null;
    _authService = null;
    _configRepository = null;
    _configService = null;
    _userRepository = null;
    _userService = null;
    _userController = null;
  }
}

