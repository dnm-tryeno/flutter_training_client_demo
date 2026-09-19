import '../models/health_guidance_result.dart';
import '../models/user_profile.dart';

class PdfReportService {
  static String generateSummaryText({
    required UserProfile profile,
    required HealthGuidanceResult result,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('           CAREPLUS HEALTH REPORT       ');
    buffer.writeln('    (Personalized General Health Summary)');
    buffer.writeln('========================================');
    buffer.writeln('Date: ${result.createdAt.day}/${result.createdAt.month}/${result.createdAt.year}');
    buffer.writeln('');
    buffer.writeln('PATIENT INFORMATION:');
    buffer.writeln('• Name: ${profile.name}');
    buffer.writeln('• Age / Gender: ${profile.age} yrs / ${profile.gender}');
    buffer.writeln('• Height / Weight: ${profile.heightCm} cm / ${profile.weightKg} kg (BMI: ${profile.bmi} - ${profile.bmiCategory})');
    if (profile.location.isNotEmpty) buffer.writeln('• Location: ${profile.location}');
    if (profile.conditions.isNotEmpty) buffer.writeln('• Known Medical Conditions: ${profile.conditions.join(", ")}');
    if (profile.allergies.isNotEmpty) buffer.writeln('• Known Allergies: ${profile.allergies.join(", ")}');
    if (profile.currentMedications.isNotEmpty) buffer.writeln('• Current Medications: ${profile.currentMedications.join(", ")}');
    if (profile.isPregnant) buffer.writeln('• Pregnancy Status: Pregnant');
    buffer.writeln('');
    buffer.writeln('REPORTED HEALTH CONCERN:');
    buffer.writeln('• Problem: ${result.reportedProblem}');
    if (result.symptoms.isNotEmpty) buffer.writeln('• Associated Symptoms: ${result.symptoms.join(", ")}');
    buffer.writeln('• Duration: ${result.duration}');
    buffer.writeln('• Guidance Level: ${result.riskLevel.nameLabel}');
    buffer.writeln('');
    buffer.writeln('POSSIBLE ASSOCIATED FACTORS (EDUCATIONAL):');
    for (final c in result.possibleCauses) {
      buffer.writeln('  - $c');
    }
    buffer.writeln('');
    buffer.writeln('SUPPORTIVE WELLNESS & LIFESTYLE SUGGESTIONS:');
    for (final tip in result.generalGuidanceTips) {
      buffer.writeln('  - $tip');
    }
    buffer.writeln('');
    if (result.foodSuggestions.isNotEmpty) {
      buffer.writeln('DIET & NUTRITION GUIDANCE:');
      for (final food in result.foodSuggestions) {
        buffer.writeln('  [${food.category}] ${food.title}: ${food.items.join(", ")}');
      }
      buffer.writeln('');
    }
    if (result.yogaExercises.isNotEmpty) {
      buffer.writeln('YOGA & GENTLE ACTIVITY:');
      for (final yoga in result.yogaExercises) {
        buffer.writeln('  • ${yoga.title} (${yoga.duration}) - ${yoga.intensity}');
      }
      buffer.writeln('');
    }
    buffer.writeln('DOCTOR CONSULTATION ADVICE:');
    buffer.writeln('${result.doctorConsultationAdvice}');
    buffer.writeln('');
    buffer.writeln('========================================');
    buffer.writeln('MANDATORY MEDICAL DISCLAIMER:');
    buffer.writeln(
        'CarePlus provides general health information only and is NOT a substitute for formal diagnosis, prescription, or clinical examination by a licensed physician. If experiencing severe or worsening symptoms, consult a doctor immediately.');
    buffer.writeln('========================================');
    return buffer.toString();
  }
}
