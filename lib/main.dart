import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/di/service_locator.dart';
import 'core/notifiers/auth_state_notifier.dart';

/// Main entry point of the application
/// Initializes Firebase, GetX for state management and go_router for navigation
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize service locator
    ServiceLocator.init();
    
    // Run the app
    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Log error details for debugging
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Run app anyway with error handling widget
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'App Initialization Error',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Root widget of the application
/// Configures MaterialApp with theme and go_router
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthStateNotifier _authStateNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Create auth state notifier instance
    _authStateNotifier = AuthStateNotifier();
    
    // Create router with auth state notifier
    _router = AppRoutes.getRouter(authStateNotifier: _authStateNotifier);
    
    // Load user data if already authenticated (app restart scenario)
    _loadUserDataIfAuthenticated();
  }

  /// Loads user data if user is already authenticated
  /// This handles the case when app restarts and user is still logged in
  Future<void> _loadUserDataIfAuthenticated() async {
    if (_authStateNotifier.isAuthenticated) {
      final userId = _authStateNotifier.currentUserId;
      if (userId != null) {
        try {
          await ServiceLocator.userController.loadUserData(userId);
        } catch (e) {
          debugPrint('Failed to load user data on app start: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _authStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pennywise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
