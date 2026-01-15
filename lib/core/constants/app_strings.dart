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
  static const String eodReminderSubtitle =
      'Receive a notification everyday at 09:00 PM';
  static const String eodReminder24Subtitle =
      'Receive a notification everyday at 2100 hrs.';
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
  static const String editEntry = 'Edit Entry';
  static const String expense = 'Expense';
  static const String income = 'Income';
  static const String howMuch = 'How much?';
  static const String note = 'Note';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String add = 'Add';
  static const String addEntry = 'Add Entry.';
  static const String foodAndDrink = 'Food and Drink';

  // Categories Screen
  static const String categoriesTitle = 'Categories';
  static const String addCategory = 'Add Category';
  static const String editCategory = 'Edit Category';
  static const String addCategories = 'Add Categories';
  static const String update = 'Update';
  static const String namePlaceholder = 'name';
  static const String hexCodePlaceholder = 'hex code';
  static const String noCategory = 'No category';

  // Color Picker
  static const String selectColor = 'Select Color';
  static const String selectColorShade = 'Select color shade';

  // Common Messages
  static const String done = 'Done';
  static const String selectCategory = 'Select Category';
  static const String noCategoriesAvailable = 'No categories available';
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String noEntriesYet = 'No entries yet. Add your first entry!';

  // Date Suffixes
  static const String dateSuffixTh = 'th';
  static const String dateSuffixSt = 'st';
  static const String dateSuffixNd = 'nd';
  static const String dateSuffixRd = 'rd';

  // Month Names (Short)
  static const String monthJan = 'Jan';
  static const String monthFeb = 'Feb';
  static const String monthMar = 'Mar';
  static const String monthApr = 'Apr';
  static const String monthMay = 'May';
  static const String monthJun = 'Jun';
  static const String monthJul = 'Jul';
  static const String monthAug = 'Aug';
  static const String monthSep = 'Sep';
  static const String monthOct = 'Oct';
  static const String monthNov = 'Nov';
  static const String monthDec = 'Dec';

  // Time Periods
  static const String am = 'AM';
  static const String pm = 'PM';

  // Error Messages
  static const String pleaseEnterValidAmount = 'Please enter a valid amount';
  static const String sheetIdMissing = 'Sheet ID is missing';
  static const String userNotAuthenticated = 'User not authenticated';
  static const String entryAddedSuccessfully = 'Entry added successfully';
  static const String failedToAddEntry = 'Failed to add entry';
  static const String failedToLoadEntries = 'Failed to load entries';
  static const String failedToLoadUserData =
      'Failed to load user data. Please try again.';
  static const String loginSuccessful = 'Login successful';
  static const String pleaseFillAllFields = 'Please fill all fields';
  static const String pleaseFillAllFieldsCorrectly =
      'Please fill all fields correctly';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String accountCreatedFailedLoad =
      'Account created but failed to load user data. Please try logging in.';
  static const String accountCreatedSuccessfully =
      'Account created successfully';
  static const String failedToLoadCurrencies = 'Failed to load currencies';
  static const String noUserDataFound =
      'No user data found. Please log in again.';
  static const String settingsSavedSuccessfully = 'Settings saved successfully';
  static const String failedToSaveSettings = 'Failed to save settings';
  static const String noCurrenciesAvailable = 'No currencies available';
  static const String selectCurrency = 'Select Currency';
  static const String logoutFailed = 'Logout failed';
  static const String categoryNameCannotBeEmpty =
      'Category name cannot be empty';
  static const String hexCodeCannotBeEmpty = 'Hex code cannot be empty';
  static const String invalidHexCodeFormat = 'Invalid hex code format';
  static const String noCategoriesYet = 'No categories yet';
  static const String deleteCategory = 'Delete Category';
  static const String deleteCategoryConfirmation =
      'Are you sure you want to delete this category?';
  static const String delete = 'Delete';
  static const String categoryDeletedSuccessfully =
      'Category deleted successfully';
  static const String failedToDeleteCategory = 'Failed to delete category';

  // Sheets Screen Messages
  static const String failedToLoadSheets = 'Failed to load sheets';
  static const String sheetCreatedSuccessfully = 'Sheet created successfully';
  static const String failedToCreateSheet = 'Failed to create sheet';
  static const String deleteSheet = 'Delete Sheet';
  static const String deleteSheetConfirmation =
      'Are you sure you want to delete this sheet? All entries in this sheet will be deleted.';
  static const String sheetDeletedSuccessfully = 'Sheet deleted successfully';
  static const String failedToDeleteSheet = 'Failed to delete sheet';
  static const String deleteEntry = 'Delete Entry';
  static const String deleteEntryConfirmation =
      'Are you sure you want to delete this entry?';
  static const String entryDeletedSuccessfully = 'Entry deleted successfully';
  static const String failedToDeleteEntry = 'Failed to delete entry';
  static const String entryUpdatedSuccessfully = 'Entry updated successfully';
  static const String failedToUpdateEntry = 'Failed to update entry';

  // Analytics Screen
  static const String analytics = 'Analytics';
  static const String week = 'Week';
  static const String month = 'Month';
  static const String totalBalance = 'Total Balance';
  static const String expensesByCategory = 'Expenses by Category';
  static const String incomeByCategory = 'Income by Category';
  static const String failedToLoadAnalytics = 'Failed to load analytics';

  // Splits Screen
  static const String comingSoon = 'Coming Soon';
  static const String comingSoonMessage =
      'Split expenses with friends and family. This feature will be available soon!';

  // Premium Features
  static const String getPremium = 'Get Premium';
  static const String analyticsPremiumMessage =
      'Upgrade to Premium to unlock detailed analytics and insights about your finances.';
}
