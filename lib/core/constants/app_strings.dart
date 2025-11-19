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
  static const String use24hrClockSubtitle = 'Show 14:30 instead of 2:30 PM';
  static const String eodReminder = 'EOD Reminder';
  static const String eodReminderSubtitle = 'Receive a notification everyday at 09:00 PM';
  static const String eodReminder24Subtitle = 'Receive a notification everyday at 2100 hrs.';
  static const String logout = 'Logout.';
  static const String defaultCurrency = 'INR';

  // Sheets Screen
  static const String addSheet = 'Add Sheet.';
  static const String addSheetName = 'Add sheet name.';
  static const String sheetNamePlaceholder = 'Seoul-ful Trip';
  static const String cancel = 'Cancel';
  static const String create = 'Create';
  static const String allCategories = 'All categories';

  // Add Entry Screen
  static const String newEntry = 'New Entry';
  static const String expense = 'Expense';
  static const String income = 'Income';
  static const String howMuch = 'How much?';
  static const String note = 'Note';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String add = 'Add';
  static const String addEntry = 'Add Entry.';
  static const String foodAndDrink = 'Food and Drink';
}

