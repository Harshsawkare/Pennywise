/// Centralized string constants for the application
/// Prevents hardcoded strings and improves maintainability
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();
  static const String appName = 'Pennywise';
  static const String appNameLowerCase = 'pennywise';

  // Sign Up Screen
  static const String createAccountTitle = 'Create';
  static const String createAccountSubtitle = 'an account.';
  static const String contactPlaceholder = 'Contact';
  static const String passwordPlaceholder = 'Password';
  static const String confirmPasswordPlaceholder = 'Confirm password';
  static const String proceedButton = 'Proceed';
  static const String orSeparator = 'or';
  static const String loginToExisting = 'Login to an existing account.';

  // Login Screen
  static const String loginTitle = 'Login';
  static const String loginSubtitle = 'to your account.';
  static const String createAccountButton = 'Create an account.';

  // Main Navigation Tabs
  static const String sheetsTab = 'Sheets.';
  static const String splitsTab = 'Splits.';
  static const String analyticsTab = 'Analytics.';
  static const String settingsTab = 'Settings.';

  // Settings Screen
  static const String categories = 'Categories';
  static const String currency = 'Currency';
  static const String use24hrClock = 'Use 24hr clock';
  static const String eodReminder = 'EOD Reminder';
  static const String eodReminderSubtitle = 'Receive a notification everyday at 09:00 PM';
  static const String eodReminder24Subtitle = 'Receive a notification everyday at 2100 hrs.';
  static const String logout = 'Logout.';
  static const String defaultCurrency = 'INR';
}

