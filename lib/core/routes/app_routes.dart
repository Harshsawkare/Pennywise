import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/main_navigation_screen.dart';
import '../notifiers/auth_state_notifier.dart';
import '../di/service_locator.dart';

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
  /// [authStateNotifier] - Optional auth state notifier for listening to auth changes
  static GoRouter getRouter({AuthStateNotifier? authStateNotifier}) {
    final authNotifier = authStateNotifier ?? AuthStateNotifier();
    
    return GoRouter(
      refreshListenable: authNotifier,
      initialLocation: login,
      redirect: (context, state) {
        final isAuthenticated = authNotifier.isAuthenticated;
        final isLoggingIn = state.matchedLocation == login;
        final isSigningUp = state.matchedLocation == signup;
        final isGoingHome = state.matchedLocation == home;

        // If user is authenticated and trying to access login/signup, redirect to home
        if (isAuthenticated && (isLoggingIn || isSigningUp)) {
          return home;
        }

        // If user is not authenticated and trying to access home, redirect to login
        if (!isAuthenticated && isGoingHome) {
          return login;
        }

        // No redirect needed
        return null;
      },
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
          builder: (context, state) {
            // Load user data if authenticated and not already loaded
            final userId = authNotifier.currentUserId;
            if (userId != null) {
              final userController = ServiceLocator.userController;
              if (userController.currentUser.value == null) {
                // Load user data asynchronously
                userController.loadUserData(userId).catchError((error) {
                  // Log error but don't block navigation
                  debugPrint('Failed to load user data: $error');
                });
              }
            }
            return const MainNavigationScreen();
          },
        ),
      ],
      // Redirect unknown routes to login
      errorBuilder: (context, state) => const LoginScreen(),
    );
  }
}
