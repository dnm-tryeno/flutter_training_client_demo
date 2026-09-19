class YogaExercise {
  final String title;
  final String duration;
  final String intensity; // 'Gentle', 'Moderate', 'Breathing/Relaxation'
  final String description;
  final List<String> steps;
  final String safetyWarning;
  final bool doctorConsultRequired;

  const YogaExercise({
    required this.title,
    required this.duration,
    required this.intensity,
    required this.description,
    required this.steps,
    this.safetyWarning = 'Exercise start karne se pehle doctor/qualified professional se salah lein.',
    this.doctorConsultRequired = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'duration': duration,
    'intensity': intensity,
    'description': description,
    'steps': steps,
    'safetyWarning': safetyWarning,
    'doctorConsultRequired': doctorConsultRequired,
  };

  factory YogaExercise.fromJson(Map<String, dynamic> json) => YogaExercise(
    title: json['title'] as String? ?? '',
    duration: json['duration'] as String? ?? '5-10 mins',
    intensity: json['intensity'] as String? ?? 'Gentle',
    description: json['description'] as String? ?? '',
    steps: (json['steps'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    safetyWarning: json['safetyWarning'] as String? ?? '',
    doctorConsultRequired: json['doctorConsultRequired'] as bool? ?? false,
  );
}
