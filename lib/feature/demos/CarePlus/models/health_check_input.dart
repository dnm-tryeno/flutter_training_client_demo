import 'user_profile.dart';

class HealthCheckInput {
  final UserProfile profile;
  final String mainProblem;
  final List<String> symptoms;
  final String duration;
  final String additionalNotes;

  const HealthCheckInput({
    required this.profile,
    required this.mainProblem,
    required this.symptoms,
    this.duration = '2 – 3 days',
    this.additionalNotes = '',
  });

  HealthCheckInput copyWith({
    UserProfile? profile,
    String? mainProblem,
    List<String>? symptoms,
    String? duration,
    String? additionalNotes,
  }) {
    return HealthCheckInput(
      profile: profile ?? this.profile,
      mainProblem: mainProblem ?? this.mainProblem,
      symptoms: symptoms ?? this.symptoms,
      duration: duration ?? this.duration,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'mainProblem': mainProblem,
      'symptoms': symptoms,
      'duration': duration,
      'additionalNotes': additionalNotes,
    };
  }

  factory HealthCheckInput.fromJson(Map<String, dynamic> json) {
    return HealthCheckInput(
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      mainProblem: json['mainProblem'] as String? ?? '',
      symptoms: (json['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      duration: json['duration'] as String? ?? '2 – 3 days',
      additionalNotes: json['additionalNotes'] as String? ?? '',
    );
  }
}
