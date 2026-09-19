import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/models/user_profile.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/models/health_check_input.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/models/health_guidance_result.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/services/health_suggestion_engine.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/services/ai_health_assistant_service.dart';
import 'package:flutter_application_1/feature/demos/CarePlus/localization/app_language.dart';

void main() {
  group('CarePlus UserProfile & BMI Tests', () {
    test('Calculates BMI and Category accurately', () {
      const normalProfile = UserProfile(
        id: 'u-1',
        name: 'Anita',
        age: 28,
        gender: 'Female',
        heightCm: 165,
        weightKg: 58,
      );

      // BMI = 58 / (1.65 * 1.65) = 21.3
      expect(normalProfile.bmi, closeTo(21.3, 0.1));
      expect(normalProfile.bmiCategory, 'Normal Weight');

      const obeseProfile = UserProfile(
        id: 'u-2',
        name: 'Raj',
        age: 45,
        gender: 'Male',
        heightCm: 170,
        weightKg: 95,
      );
      // BMI = 95 / (1.7 * 1.7) = 32.9
      expect(obeseProfile.bmi, closeTo(32.9, 0.1));
      expect(obeseProfile.bmiCategory, 'Obese');
    });

    test('UserProfile JSON serialization roundtrip', () {
      final profile = UserProfile(
        id: 'test-123',
        name: 'Rohan Sharma',
        age: 34,
        gender: 'Male',
        heightCm: 175.0,
        weightKg: 72.0,
        location: 'Mumbai',
        conditions: const ['Diabetes'],
        allergies: const ['Penicillin'],
        currentMedications: const ['Metformin'],
        isPregnant: false,
      );

      final json = profile.toJson();
      final restored = UserProfile.fromJson(json);

      expect(restored.name, 'Rohan Sharma');
      expect(restored.age, 34);
      expect(restored.conditions, contains('Diabetes'));
      expect(restored.allergies, contains('Penicillin'));
      expect(restored.currentMedications, contains('Metformin'));
    });
  });

  group('CarePlus Health Suggestion Engine Tests', () {
    test('Detects Red-Flag Emergency symptoms immediately', () {
      const profile = UserProfile(
        id: 'u-3',
        name: 'Patient',
        age: 50,
        gender: 'Male',
        heightCm: 170,
        weightKg: 70,
      );

      final emergencyInput = HealthCheckInput(
        profile: profile,
        mainProblem: 'Severe chest pain and difficulty breathing',
        symptoms: const ['Chest tightness', 'Shortness of breath'],
        duration: 'Today / Less than 24 hours',
      );

      final result = HealthSuggestionEngine.analyze(emergencyInput);

      expect(result.riskLevel, RiskLevel.emergency);
      expect(result.isEmergency, isTrue);
      expect(result.emergencyRedFlags.isNotEmpty, isTrue);
      expect(result.disclaimerNote, contains('EMERGENCY'));
      expect(result.doctorConsultationAdvice.toLowerCase(), contains('emergency'));
    });

    test('Generates appropriate non-prescriptive guidance for Acidity', () {
      const profile = UserProfile(
        id: 'u-4',
        name: 'Patient',
        age: 26,
        gender: 'Female',
        heightCm: 160,
        weightKg: 55,
      );

      final acidityInput = HealthCheckInput(
        profile: profile,
        mainProblem: 'Pet me dard hai aur acidity ho rahi hai',
        symptoms: const ['Acidity', 'Nausea'],
        duration: '2 – 3 days',
      );

      final result = HealthSuggestionEngine.analyze(acidityInput);

      expect(result.riskLevel, isNot(RiskLevel.emergency));
      expect(result.foodSuggestions.any((f) => f.title.contains('Alkaline')), isTrue);
      expect(result.yogaExercises.any((y) => y.title.contains('Vajrasana')), isTrue);
      expect(result.medicineSafetyItems.any((m) => m.name.contains('Antacids')), isTrue);
      expect(result.possibleCauses.isNotEmpty, isTrue);
    });

    test('Generates safe yoga and hydration for Headache', () {
      const profile = UserProfile(
        id: 'u-5',
        name: 'Patient',
        age: 30,
        gender: 'Male',
        heightCm: 172,
        weightKg: 68,
      );

      final headacheInput = HealthCheckInput(
        profile: profile,
        mainProblem: 'Sir dard hai since yesterday',
        symptoms: const ['Headache'],
        duration: 'Today / Less than 24 hours',
      );

      final result = HealthSuggestionEngine.analyze(headacheInput);

      expect(result.possibleCauses.any((c) => c.toLowerCase().contains('tension') || c.toLowerCase().contains('dehydration')), isTrue);
      expect(result.generalGuidanceTips.any((t) => t.toLowerCase().contains('water') || t.toLowerCase().contains('hydration') || t.toLowerCase().contains('rest')), isTrue);
    });
  });

  group('CarePlus AI Health Assistant Tests', () {
    test('Answers in Hinglish for Hinglish input queries', () {
      final response = AIHealthAssistantService.processUserQuery(
        'Mujhe acidity hai, kya khana chahiye?',
        AppLanguage.hinglish,
      );

      expect(response.text, contains('Acidity'));
      expect(
        response.text,
        anyOf(contains('Kela'), contains('kela'), contains('milk'), contains('doodh')),
      );
      expect(response.quickOptions.isNotEmpty, isTrue);
    });

    test('Intercepts Emergency queries in AI chat with high-priority alert', () {
      final response = AIHealthAssistantService.processUserQuery(
        'Mere chest pain ho raha hai aur saans lene me takleef hai',
        AppLanguage.hinglish,
      );

      expect(response.isEmergencyAlert, isTrue);
      expect(response.text, contains('EMERGENCY'));
    });
  });

  group('CarePlus Multi-Language Localization Tests', () {
    test('Returns correct strings across English, Hinglish, and Hindi', () {
      expect(AppStrings.get('app_name', AppLanguage.english), 'CarePlus');
      expect(AppStrings.get('tagline', AppLanguage.english), 'Your Simple Health Guidance Companion');
      expect(AppStrings.get('tagline', AppLanguage.hinglish), 'Sehat ki simple aur safe guidance.');
      expect(AppStrings.get('home_main_cta', AppLanguage.hindi), contains('स्वास्थ्य जांचें'));
    });
  });
}
