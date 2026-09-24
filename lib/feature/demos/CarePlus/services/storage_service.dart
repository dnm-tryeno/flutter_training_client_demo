import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/health_history_record.dart';
import '../localization/app_language.dart';

class StorageService {
  static const String _keyDisclaimerAccepted = 'careplus_disclaimer_accepted';
  static const String _keyUserProfile = 'careplus_user_profile';
  static const String _keyHistory = 'careplus_health_history';
  static const String _keyLanguage = 'careplus_language';
  static const String _keyDarkMode = 'careplus_dark_mode';
  static const String _keyElderlyMode = 'careplus_elderly_mode';
  static const String _keyEmergencyNumber = 'careplus_emergency_number';

  static Future<bool> isDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDisclaimerAccepted) ?? false;
  }

  static Future<void> setDisclaimerAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDisclaimerAccepted, accepted);
  }

  static Future<UserProfile> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUserProfile);
    if (raw == null || raw.isEmpty) {
      return UserProfile.defaultProfile();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return UserProfile.defaultProfile();
    }
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserProfile, jsonEncode(profile.toJson()));
  }

  static Future<List<HealthHistoryRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_keyHistory);
    if (rawList == null || rawList.isEmpty) {
      return [];
    }
    final results = <HealthHistoryRecord>[];
    for (final item in rawList) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        results.add(HealthHistoryRecord.fromJson(map));
      } catch (_) {}
    }
    // Sort descending by date
    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  static Future<void> saveHistoryRecord(HealthHistoryRecord record) async {
    final existing = await loadHistory();
    existing.insert(0, record);
    final rawList = existing.map((e) => jsonEncode(e.toJson())).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHistory, rawList);
  }

  static Future<void> deleteHistoryRecord(String id) async {
    final existing = await loadHistory();
    existing.removeWhere((e) => e.id == id);
    final rawList = existing.map((e) => jsonEncode(e.toJson())).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHistory, rawList);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserProfile);
    await prefs.remove(_keyHistory);
    await prefs.remove(_keyDisclaimerAccepted);
  }

  static Future<AppLanguage> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLanguage);
    if (code == 'hi') return AppLanguage.hindi;
    if (code == 'hinglish') return AppLanguage.hinglish;
    return AppLanguage.english;
  }

  static Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language.code);
  }

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  static Future<bool> loadElderlyMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyElderlyMode) ?? false;
  }

  static Future<void> saveElderlyMode(bool isElderly) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyElderlyMode, isElderly);
  }

  static Future<String> loadEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmergencyNumber) ?? '112';
  }

  static Future<void> saveEmergencyNumber(String num) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmergencyNumber, num);
  }
}
