import '../models/health_guidance_result.dart';
import '../models/user_profile.dart';
import '../localization/app_language.dart';

class PdfReportService {
  static String generateSummaryText({
    required UserProfile profile,
    required HealthGuidanceResult result,
    AppLanguage language = AppLanguage.english,
  }) {
    final buffer = StringBuffer();
    final isHindi = language == AppLanguage.hindi;
    final isHinglish = language == AppLanguage.hinglish;

    if (isHindi) {
      buffer.writeln('========================================');
      buffer.writeln('          केयरप्लस स्वास्थ्य रिपोर्ट       ');
      buffer.writeln('    (व्यक्तिगत स्वास्थ्य मार्गदर्शन सारांश)');
      buffer.writeln('========================================');
      buffer.writeln('तारीख: ${result.createdAt.day}/${result.createdAt.month}/${result.createdAt.year}');
      buffer.writeln('');
      buffer.writeln('रोगी की जानकारी (PATIENT INFO):');
      buffer.writeln('• नाम: ${profile.name}');
      buffer.writeln('• आयु / लिंग: ${profile.age} वर्ष / ${profile.gender}');
      buffer.writeln('• ऊंचाई / वजन: ${profile.heightCm} सेमी / ${profile.weightKg} किग्रा (BMI: ${profile.bmi.toStringAsFixed(1)} - ${profile.bmiCategory})');
      if (profile.location.isNotEmpty) buffer.writeln('• स्थान: ${profile.location}');
      if (profile.conditions.isNotEmpty) buffer.writeln('• पहले से मौजूद स्वास्थ्य स्थितियां: ${profile.conditions.join(", ")}');
      if (profile.allergies.isNotEmpty) buffer.writeln('• एलर्जी: ${profile.allergies.join(", ")}');
      if (profile.currentMedications.isNotEmpty) buffer.writeln('• वर्तमान दवाइयां: ${profile.currentMedications.join(", ")}');
      if (profile.isPregnant) buffer.writeln('• गर्भावस्था स्थिति: हाँ (गर्भवती)');
      buffer.writeln('');
      buffer.writeln('स्वास्थ्य समस्या (HEALTH CONCERN):');
      buffer.writeln('• मुख्य समस्या: ${result.reportedProblem}');
      if (result.symptoms.isNotEmpty) buffer.writeln('• लक्षण: ${result.symptoms.join(", ")}');
      buffer.writeln('• समस्या की अवधि: ${result.duration}');
      buffer.writeln('• स्थिति का स्तर: ${result.riskLevel.label(language)}');
      buffer.writeln('');
      buffer.writeln('संभावित कारण (POSSIBLE FACTORS):');
      for (final c in result.possibleCauses) {
        buffer.writeln('  - $c');
      }
      buffer.writeln('');
      buffer.writeln('सहायक जीवनशैली व देखभाल सलाह (LIFESTYLE & CARE):');
      for (final tip in result.generalGuidanceTips) {
        buffer.writeln('  - $tip');
      }
      buffer.writeln('');
      if (result.foodSuggestions.isNotEmpty) {
        buffer.writeln('आहार एवं पोषण संबंधी सुझाव (DIET & NUTRITION):');
        for (final food in result.foodSuggestions) {
          buffer.writeln('  • ${food.title} [${food.category}]: ${food.items.join(", ")}');
        }
        buffer.writeln('');
      }
      if (result.yogaExercises.isNotEmpty) {
        buffer.writeln('योग एवं सौम्य व्यायाम (YOGA & EXERCISE):');
        for (final yoga in result.yogaExercises) {
          buffer.writeln('  • ${yoga.title} (${yoga.duration}) - ${yoga.intensity}');
        }
        buffer.writeln('');
      }
      buffer.writeln('डॉक्टर परामर्श सलाह (DOCTOR ADVICE):');
      buffer.writeln('${result.doctorConsultationAdvice}');
      buffer.writeln('');
      buffer.writeln('========================================');
      buffer.writeln('महत्वपूर्ण अस्वीकरण (MEDICAL DISCLAIMER):');
      buffer.writeln('यह रिपोर्ट केवल सामान्य स्वास्थ्य जानकारी व शिक्षा हेतु है। यह डॉक्टर के व्यक्तिगत परीक्षण, निदान या पर्चे का विकल्प नहीं है। गंभीर स्थिति में तुरंत डॉक्टर से संपर्क करें।');
      buffer.writeln('========================================');
    } else if (isHinglish) {
      buffer.writeln('========================================');
      buffer.writeln('          CAREPLUS HEALTH REPORT        ');
      buffer.writeln('    (Personalized Health Summary)       ');
      buffer.writeln('========================================');
      buffer.writeln('Date: ${result.createdAt.day}/${result.createdAt.month}/${result.createdAt.year}');
      buffer.writeln('');
      buffer.writeln('PATIENT INFORMATION:');
      buffer.writeln('• Naam: ${profile.name}');
      buffer.writeln('• Age / Gender: ${profile.age} yrs / ${profile.gender}');
      buffer.writeln('• Height / Weight: ${profile.heightCm} cm / ${profile.weightKg} kg (BMI: ${profile.bmi.toStringAsFixed(1)})');
      if (profile.conditions.isNotEmpty) buffer.writeln('• Known Conditions: ${profile.conditions.join(", ")}');
      if (profile.allergies.isNotEmpty) buffer.writeln('• Allergies: ${profile.allergies.join(", ")}');
      buffer.writeln('');
      buffer.writeln('HEALTH CONCERN:');
      buffer.writeln('• Problem: ${result.reportedProblem}');
      if (result.symptoms.isNotEmpty) buffer.writeln('• Symptoms: ${result.symptoms.join(", ")}');
      buffer.writeln('• Duration: ${result.duration}');
      buffer.writeln('• Guidance Level: ${result.riskLevel.label(language)}');
      buffer.writeln('');
      buffer.writeln('DOCTOR CONSULTATION ADVICE:');
      buffer.writeln('${result.doctorConsultationAdvice}');
      buffer.writeln('');
      buffer.writeln('========================================');
      buffer.writeln('DISCLAIMER: CarePlus app general health guidance ke liye hai, clinical diagnosis ya doctor consultation ka substitute nahi hai.');
      buffer.writeln('========================================');
    } else {
      buffer.writeln('========================================');
      buffer.writeln('           CAREPLUS HEALTH REPORT       ');
      buffer.writeln('    (Personalized General Health Summary)');
      buffer.writeln('========================================');
      buffer.writeln('Date: ${result.createdAt.day}/${result.createdAt.month}/${result.createdAt.year}');
      buffer.writeln('');
      buffer.writeln('PATIENT INFORMATION:');
      buffer.writeln('• Name: ${profile.name}');
      buffer.writeln('• Age / Gender: ${profile.age} yrs / ${profile.gender}');
      buffer.writeln('• Height / Weight: ${profile.heightCm} cm / ${profile.weightKg} kg (BMI: ${profile.bmi.toStringAsFixed(1)} - ${profile.bmiCategory})');
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
      buffer.writeln('• Guidance Level: ${result.riskLevel.label(language)}');
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
    }
    return buffer.toString();
  }
}
