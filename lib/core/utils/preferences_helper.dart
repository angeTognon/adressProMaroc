import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyIsGuest = 'is_guest';
  static const String _keyIsProfessional = 'is_professional';
  static const String _keyLoginTutorialCompleted = 'login_tutorial_completed';
  static const String _keyBookButtonTutorialCompleted = 'book_button_tutorial_completed';

  // Onboarding
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, value);
  }

  // Auth
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGuest) ?? false;
  }

  static Future<void> setGuest(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuest, value);
  }

  static Future<bool> isProfessional() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsProfessional) ?? false;
  }

  static Future<void> setIsProfessional(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsProfessional, value);
  }

  // Login Tutorial
  static Future<bool> isLoginTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoginTutorialCompleted) ?? false;
  }

  static Future<void> setLoginTutorialCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoginTutorialCompleted, value);
  }

  // Book Button Tutorial
  static Future<bool> isBookButtonTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBookButtonTutorialCompleted) ?? false;
  }

  static Future<void> setBookButtonTutorialCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBookButtonTutorialCompleted, value);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

