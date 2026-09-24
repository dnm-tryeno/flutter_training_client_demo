import 'strings_en.dart';
import 'strings_hinglish.dart';
import 'strings_hi.dart';

enum AppLanguage {
  english,
  hinglish,
  hindi,
}

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hinglish:
        return 'hinglish';
      case AppLanguage.hindi:
        return 'hi';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hinglish:
        return 'Hinglish';
      case AppLanguage.hindi:
        return 'हिन्दी (Hindi)';
    }
  }
}

class AppStrings {
  AppStrings._();

  static String get(String key, AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return stringsEn[key] ?? stringsEn[key] ?? key;
      case AppLanguage.hinglish:
        return stringsHinglish[key] ?? stringsEn[key] ?? key;
      case AppLanguage.hindi:
        return stringsHi[key] ?? stringsEn[key] ?? key;
    }
  }
}
