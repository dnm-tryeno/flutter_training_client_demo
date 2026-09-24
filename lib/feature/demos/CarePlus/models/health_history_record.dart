import 'health_guidance_result.dart';
import 'health_check_input.dart';

class HealthHistoryRecord {
  final String id;
  final DateTime date;
  final String reportedProblem;
  final List<String> symptoms;
  final RiskLevel riskLevel;
  final String doctorRecommendation;
  final HealthGuidanceResult guidanceResult;
  final HealthCheckInput input;

  const HealthHistoryRecord({
    required this.id,
    required this.date,
    required this.reportedProblem,
    required this.symptoms,
    required this.riskLevel,
    required this.doctorRecommendation,
    required this.guidanceResult,
    required this.input,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'reportedProblem': reportedProblem,
    'symptoms': symptoms,
    'riskLevel': riskLevel.index,
    'doctorRecommendation': doctorRecommendation,
    'guidanceResult': guidanceResult.toJson(),
    'input': input.toJson(),
  };

  factory HealthHistoryRecord.fromJson(Map<String, dynamic> json) => HealthHistoryRecord(
    id: json['id'] as String? ?? '',
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
    reportedProblem: json['reportedProblem'] as String? ?? '',
    symptoms: (json['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    riskLevel: RiskLevel.values[(json['riskLevel'] as num?)?.toInt() ?? 0],
    doctorRecommendation: json['doctorRecommendation'] as String? ?? '',
    guidanceResult: HealthGuidanceResult.fromJson(json['guidanceResult'] as Map<String, dynamic>),
    input: HealthCheckInput.fromJson(json['input'] as Map<String, dynamic>),
  );
}
