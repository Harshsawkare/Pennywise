/// User tier enum representing subscription tier
/// Follows clean architecture by keeping domain layer enum simple
enum UserTier {
  /// Freemium tier (default)
  freemium,

  /// Premium tier
  premium;

  /// Converts enum to string value for Firestore storage
  String get value => name;

  /// Creates UserTier from string value
  /// [value] - String value from Firestore
  /// Returns UserTier enum, defaults to freemium if invalid
  static UserTier fromString(String? value) {
    if (value == null) return UserTier.freemium;

    switch (value.toLowerCase()) {
      case 'freemium':
        return UserTier.freemium;
      case 'premium':
        return UserTier.premium;
      default:
        return UserTier.freemium;
    }
  }
}
