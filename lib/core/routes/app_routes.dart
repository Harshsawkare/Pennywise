import 'package:go_router/go_router.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/main_navigation_screen.dart';

/// App routing configuration using go_router
/// Centralizes all route definitions for maintainability
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// Route paths
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  /// Get the GoRouter configuration
  static GoRouter getRouter() {
    return GoRouter(
      initialLocation: login,
      routes: [
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signup,
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const MainNavigationScreen(),
        ),
      ],
      // Redirect unknown routes to login
      errorBuilder: (context, state) => const LoginScreen(),
    );
  }
}
