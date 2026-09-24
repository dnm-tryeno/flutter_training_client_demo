import 'medicine_safety_item.dart';
import 'food_suggestion.dart';
import 'yoga_exercise.dart';

class AdminStats {
  final int totalUsers;
  final int totalHealthChecks;
  final int emergencyAlertsTriggered;
  final int totalEducationalMedicines;
  final int totalDietGuides;
  final int totalYogaGuides;
  final String lastContentReviewDate;

  const AdminStats({
    required this.totalUsers,
    required this.totalHealthChecks,
    required this.emergencyAlertsTriggered,
    required this.totalEducationalMedicines,
    required this.totalDietGuides,
    required this.totalYogaGuides,
    required this.lastContentReviewDate,
  });
}

class AdminContentState {
  final List<MedicineSafetyItem> medicines;
  final List<FoodSuggestion> foods;
  final List<YogaExercise> yogaRoutines;
  final String aiSystemPrompt;
  final String emergencyNumber;
  final String disclaimerText;
  final bool contentReviewModeActive;

  const AdminContentState({
    required this.medicines,
    required this.foods,
    required this.yogaRoutines,
    required this.aiSystemPrompt,
    required this.emergencyNumber,
    required this.disclaimerText,
    this.contentReviewModeActive = true,
  });

  AdminContentState copyWith({
    List<MedicineSafetyItem>? medicines,
    List<FoodSuggestion>? foods,
    List<YogaExercise>? yogaRoutines,
    String? aiSystemPrompt,
    String? emergencyNumber,
    String? disclaimerText,
    bool? contentReviewModeActive,
  }) {
    return AdminContentState(
      medicines: medicines ?? this.medicines,
      foods: foods ?? this.foods,
      yogaRoutines: yogaRoutines ?? this.yogaRoutines,
      aiSystemPrompt: aiSystemPrompt ?? this.aiSystemPrompt,
      emergencyNumber: emergencyNumber ?? this.emergencyNumber,
      disclaimerText: disclaimerText ?? this.disclaimerText,
      contentReviewModeActive: contentReviewModeActive ?? this.contentReviewModeActive,
    );
  }
}
