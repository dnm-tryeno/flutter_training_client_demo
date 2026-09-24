import '../localization/app_language.dart';
import 'food_suggestion.dart';
import 'yoga_exercise.dart';
import 'medicine_safety_item.dart';

enum RiskLevel {
  low,
  moderate,
  consultDoctor,
  emergency,
}

extension RiskLevelExtension on RiskLevel {
  String get nameLabel {
    switch (this) {
      case RiskLevel.low:
        return 'General Self-Care / Low Risk';
      case RiskLevel.moderate:
        return 'Moderate Caution Needed';
      case RiskLevel.consultDoctor:
        return 'Doctor Consultation Recommended';
      case RiskLevel.emergency:
        return 'EMERGENCY: Immediate Medical Care Needed';
    }
  }

  String get hinglishLabel {
    switch (this) {
      case RiskLevel.low:
        return 'Normal / General Care';
      case RiskLevel.moderate:
        return 'Moderate — Sambhalke Care Karein';
      case RiskLevel.consultDoctor:
        return 'Doctor se salah lena recommended hai';
      case RiskLevel.emergency:
        return 'EMERGENCY: Turant Doctor ke paas jayein';
    }
  }

  String label(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        switch (this) {
          case RiskLevel.low:
            return 'सामान्य / घरेलू देखभाल';
          case RiskLevel.moderate:
            return 'मध्यम — सावधानी आवश्यक';
          case RiskLevel.consultDoctor:
            return 'डॉक्टर से परामर्श की सिफारिश';
          case RiskLevel.emergency:
            return 'आपातकाल: तुरंत अस्पताल जाएं';
        }
      case AppLanguage.hinglish:
        return hinglishLabel;
      case AppLanguage.english:
        return nameLabel;
    }
  }
}

class HealthGuidanceResult {
  final String id;
  final String reportedProblem;
  final List<String> symptoms;
  final String duration;
  final RiskLevel riskLevel;
  final String riskSummary;
  final List<String> possibleCauses;
  final String disclaimerNote;
  final List<String> generalGuidanceTips;
  final List<FoodSuggestion> foodSuggestions;
  final List<YogaExercise> yogaExercises;
  final List<String> lifestyleTips;
  final List<MedicineSafetyItem> medicineSafetyItems;
  final String doctorConsultationAdvice;
  final String recommendedSpecialist;
  final bool isEmergency;
  final List<String> emergencyRedFlags;
  final DateTime createdAt;

  const HealthGuidanceResult({
    required this.id,
    required this.reportedProblem,
    required this.symptoms,
    required this.duration,
    required this.riskLevel,
    required this.riskSummary,
    required this.possibleCauses,
    this.disclaimerNote =
        'These symptoms can be associated with several factors. This is general educational guidance, not a medical diagnosis. A healthcare professional can evaluate you properly.',
    required this.generalGuidanceTips,
    required this.foodSuggestions,
    required this.yogaExercises,
    required this.lifestyleTips,
    required this.medicineSafetyItems,
    required this.doctorConsultationAdvice,
    this.recommendedSpecialist = 'General Physician',
    this.isEmergency = false,
    this.emergencyRedFlags = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'reportedProblem': reportedProblem,
    'symptoms': symptoms,
    'duration': duration,
    'riskLevel': riskLevel.index,
    'riskSummary': riskSummary,
    'possibleCauses': possibleCauses,
    'disclaimerNote': disclaimerNote,
    'generalGuidanceTips': generalGuidanceTips,
    'foodSuggestions': foodSuggestions.map((e) => e.toJson()).toList(),
    'yogaExercises': yogaExercises.map((e) => e.toJson()).toList(),
    'lifestyleTips': lifestyleTips,
    'medicineSafetyItems': medicineSafetyItems.map((e) => e.toJson()).toList(),
    'doctorConsultationAdvice': doctorConsultationAdvice,
    'recommendedSpecialist': recommendedSpecialist,
    'isEmergency': isEmergency,
    'emergencyRedFlags': emergencyRedFlags,
    'createdAt': createdAt.toIso8601String(),
  };

  factory HealthGuidanceResult.fromJson(Map<String, dynamic> json) => HealthGuidanceResult(
    id: json['id'] as String? ?? '',
    reportedProblem: json['reportedProblem'] as String? ?? '',
    symptoms: (json['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    duration: json['duration'] as String? ?? '',
    riskLevel: RiskLevel.values[(json['riskLevel'] as num?)?.toInt() ?? 0],
    riskSummary: json['riskSummary'] as String? ?? '',
    possibleCauses: (json['possibleCauses'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    disclaimerNote: json['disclaimerNote'] as String? ?? '',
    generalGuidanceTips: (json['generalGuidanceTips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    foodSuggestions: (json['foodSuggestions'] as List<dynamic>?)?.map((e) => FoodSuggestion.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    yogaExercises: (json['yogaExercises'] as List<dynamic>?)?.map((e) => YogaExercise.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    lifestyleTips: (json['lifestyleTips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    medicineSafetyItems: (json['medicineSafetyItems'] as List<dynamic>?)?.map((e) => MedicineSafetyItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    doctorConsultationAdvice: json['doctorConsultationAdvice'] as String? ?? '',
    recommendedSpecialist: json['recommendedSpecialist'] as String? ?? 'General Physician',
    isEmergency: json['isEmergency'] as bool? ?? false,
    emergencyRedFlags: (json['emergencyRedFlags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
  );
}
