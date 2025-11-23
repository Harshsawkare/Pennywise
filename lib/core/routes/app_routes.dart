import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/main_navigation_screen.dart';
import '../../presentation/screens/sheet_entries_screen.dart';
import '../../presentation/screens/add_entry_screen.dart';
import '../../presentation/screens/edit_entry_screen.dart';
import '../../presentation/screens/categories_screen.dart';
import '../../presentation/screens/add_edit_category_screen.dart';
import '../../domain/models/sheet_model.dart';
import '../../domain/models/category_model.dart';
import '../../domain/models/entry_model.dart';
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
  static const String sheetEntries = '/sheet/:sheetId';
  static const String addEntry = '/add-entry';
  static const String editEntry = '/edit-entry';
  static const String categories = '/categories';
  static const String addCategory = '/add-category';
  static const String editCategory = '/edit-category';

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
          routes: [
            GoRoute(
              path: 'sheet/:sheetId',
              name: 'sheetEntries',
              builder: (context, state) {
                final sheetId = state.pathParameters['sheetId'] ?? '';
                // Get sheet from extra state if provided, otherwise create placeholder
                // The controller will load the actual sheet data
                final sheet = state.extra as SheetModel? ??
                    SheetModel(
                      id: sheetId,
                      name: 'Sheet', // Will be loaded by controller
                      totalAmount: 0.0,
                      createdOn: DateTime.now(),
                      updatedOn: DateTime.now(),
                      userId: '',
                      totalIncome: 0.0,
                      totalExpense: 0.0,
                    );
                return SheetEntriesScreen(sheet: sheet);
              },
            ),
            GoRoute(
              path: 'add-entry',
              name: 'addEntry',
              builder: (context, state) {
                final sheetId = state.uri.queryParameters['sheetId'];
                return AddEntryScreen(sheetId: sheetId);
              },
            ),
            GoRoute(
              path: 'edit-entry',
              name: 'editEntry',
              builder: (context, state) {
                final entry = state.extra as EntryModel?;
                return EditEntryScreen(entry: entry);
              },
            ),
            GoRoute(
              path: 'categories',
              name: 'categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
            GoRoute(
              path: 'add-category',
              name: 'addCategory',
              builder: (context, state) => const AddEditCategoryScreen(),
            ),
            GoRoute(
              path: 'edit-category',
              name: 'editCategory',
              builder: (context, state) {
                final category = state.extra as CategoryModel?;
                return AddEditCategoryScreen(category: category);
              },
            ),
          ],
        ),
      ],
      // Redirect unknown routes to login
      errorBuilder: (context, state) => const LoginScreen(),
    );
  }
}
