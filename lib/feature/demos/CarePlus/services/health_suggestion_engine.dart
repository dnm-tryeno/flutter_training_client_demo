import 'package:uuid/uuid.dart';
import '../models/health_check_input.dart';
import '../models/health_guidance_result.dart';
import '../models/food_suggestion.dart';
import '../models/yoga_exercise.dart';
import '../models/medicine_safety_item.dart';

class HealthSuggestionEngine {
  static const _uuid = Uuid();

  // Pre-compiled Educational Medicine Safety Database
  static final List<MedicineSafetyItem> verifiedMedicineDatabase = [
    const MedicineSafetyItem(
      id: 'med-paracetamol',
      name: 'Paracetamol / Acetaminophen (Educational Overview)',
      genericCategory: 'Analgesic & Antipyretic (Pain & Fever Reliever)',
      generalPurpose:
          'Commonly used worldwide for temporary relief of mild-to-moderate headaches, body aches, and fever.',
      commonPrecautions: [
        'Do not exceed maximum daily limit (overdose can cause severe liver damage).',
        'Avoid consuming alcohol while taking paracetamol.',
        'Check labels of other cold/cough remedies to prevent accidental double dosing.',
      ],
      commonSideEffects: [
        'Rare at standard doses: mild nausea, allergic skin rash.',
        'Liver toxicity if taken in excessive quantities.',
      ],
      importantInteractions: ['Warfarin (blood thinners)', 'Alcohol', 'Other acetaminophen-containing products'],
      whoShouldAskDoctor: [
        'Individuals with chronic liver or kidney disease.',
        'People consuming regular alcohol.',
        'Pregnant or breastfeeding women.',
      ],
      sourceReference: 'WHO Model Formulary / National Health Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. S. Mehta, MD (Internal Medicine)',
    ),
    const MedicineSafetyItem(
      id: 'med-antacid',
      name: 'Antacids & Alginates (Educational Overview)',
      genericCategory: 'Gastric Acid Neutralizer',
      generalPurpose: 'Provides rapid, temporary relief from heartburn, acid indigestion, and sour stomach.',
      commonPrecautions: [
        'Should not be taken continuously for more than 14 days without medical advice.',
        'Take 1 to 2 hours apart from other medications as they can reduce absorption of other medicines.',
      ],
      commonSideEffects: ['Magnesium-containing antacids may cause diarrhea; Aluminum-containing may cause constipation.'],
      importantInteractions: ['Iron supplements', 'Antibiotics (Tetracyclines, Fluoroquinolones)', 'Digoxin'],
      whoShouldAskDoctor: [
        'Patients with kidney dysfunction or high blood pressure (due to sodium content).',
        'Anyone experiencing chest pain radiating to arm or jaw.',
      ],
      sourceReference: 'British National Formulary (BNF) & AIIMS Clinical Protocols',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. V. Rao, MD (Gastroenterology)',
    ),
    const MedicineSafetyItem(
      id: 'med-ors',
      name: 'Oral Rehydration Salts (ORS) (Educational Overview)',
      genericCategory: 'Electrolyte & Fluid Replacement',
      generalPurpose:
          'Replenishes vital water and electrolytes lost during diarrhea, vomiting, excessive sweating, or heat exhaustion.',
      commonPrecautions: [
        'Always prepare in the exact volume of clean drinking water specified on the packet (do not dilute or make too concentrated).',
        'Use freshly prepared solution within 24 hours.',
      ],
      commonSideEffects: ['Extremely safe when mixed properly in clean water.'],
      importantInteractions: ['Generally safe with most medications.'],
      whoShouldAskDoctor: [
        'Patients with severe kidney failure or severe heart failure where fluid/potassium is restricted.',
      ],
      sourceReference: 'WHO Guidelines on Management of Dehydration',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'CarePlus Medical Editorial Board',
    ),
    const MedicineSafetyItem(
      id: 'med-cetirizine',
      name: 'Cetirizine / Antihistamines (Educational Overview)',
      genericCategory: 'Second-Generation Antihistamine',
      generalPurpose:
          'Helps alleviate allergy symptoms such as sneezing, runny nose, itchy watery eyes, and allergic skin hives.',
      commonPrecautions: [
        'May cause mild drowsiness in some individuals; exercise caution when driving or operating heavy machinery.',
        'Avoid alcohol consumption as it increases drowsiness.',
      ],
      commonSideEffects: ['Mild drowsiness, dry mouth, headache, fatigue.'],
      importantInteractions: ['CNS depressants', 'Sedatives', 'Alcohol'],
      whoShouldAskDoctor: [
        'Elderly patients, pregnant or nursing mothers, and individuals with severe kidney impairment.',
      ],
      sourceReference: 'FDA & ICMR Drug Information Directory',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. P. Roy, MD (Pulmonology & Allergy)',
    ),
    const MedicineSafetyItem(
      id: 'med-pain-relief',
      name: 'Topical Pain Relief Gel & Mild Analgesics (Educational Overview)',
      genericCategory: 'Topical Counter-Irritant & Pain Reliever',
      generalPurpose:
          'Provides localized temporary relief from lower back ache, muscle sprains, stiffness, and neck fatigue.',
      commonPrecautions: [
        'Apply only to unbroken, non-irritated skin; avoid contact with eyes, nose, or mouth.',
        'Wash hands thoroughly with soap after application.',
        'Do not apply heating pads or tightly bind the area immediately after using pain relief ointment.',
        'Do not exceed recommended frequency (2–3 times daily).',
      ],
      commonSideEffects: ['Mild temporary warmth, tingling, or skin redness at the site of application.'],
      importantInteractions: ['Other medicated creams on the same area', 'Oral NSAIDs (if ointment contains diclofenac)'],
      whoShouldAskDoctor: [
        'Pregnant or nursing mothers before using medicated pain gels.',
        'Individuals with sensitive skin, asthma, or aspirin allergies.',
        'Anyone whose pain radiates down the legs or persists beyond 5–7 days.',
      ],
      sourceReference: 'WHO Essential Medicines & Indian Pharmacopoeia Guidelines',
      lastReviewedDate: 'September 2026',
      medicalReviewer: 'Dr. K. Saxena, MS (Orthopedics & Spine Care)',
    ),
  ];

  static HealthGuidanceResult analyze(HealthCheckInput input) {
    final problem = input.mainProblem.toLowerCase();
    final symptoms = input.symptoms.map((s) => s.toLowerCase()).toList();
    final profile = input.profile;
    final allText = '$problem ${symptoms.join(" ")}'.toLowerCase();

    // 1. Red Flag / Emergency Symptoms Check
    final emergencyTriggers = <String>[];
    if (allText.contains('chest pain') || allText.contains('chhati me dard') || allText.contains('seene me dard')) {
      emergencyTriggers.add('Severe Chest Pain / Pressure');
    }
    if (allText.contains('breath') || allText.contains('saans lene me') || allText.contains('shortness of breath') || allText.contains('suffocation')) {
      emergencyTriggers.add('Difficulty Breathing or Severe Shortness of Breath');
    }
    if (allText.contains('unconscious') || allText.contains('behosh') || allText.contains('fainting') || allText.contains('loss of consciousness')) {
      emergencyTriggers.add('Loss of Consciousness or Sudden Fainting');
    }
    if (allText.contains('stroke') || allText.contains('paralysis') || allText.contains('slurred speech') || allText.contains('face droop') || allText.contains('ek taraf kamzori')) {
      emergencyTriggers.add('Sudden Facial Droop / Weakness on One Side / Slurred Speech');
    }
    if (allText.contains('heavy bleeding') || allText.contains('khoon behna') || allText.contains('blood vomiting') || allText.contains('khoon ki ulti')) {
      emergencyTriggers.add('Heavy Uncontrolled Bleeding or Vomiting Blood');
    }

    if (emergencyTriggers.isNotEmpty) {
      return _buildEmergencyResult(input, emergencyTriggers);
    }

    // 2. Classify Risk Level & Clinical Domains
    var riskLevel = RiskLevel.low;
    var riskSummary = 'Mild symptoms suitable for supportive home care and hydration.';
    var recommendedSpecialist = 'General Physician';
    final possibleCauses = <String>[];
    final generalTips = <String>[];
    final foodList = <FoodSuggestion>[];
    final yogaList = <YogaExercise>[];
    final lifestyleTips = <String>[];
    final medList = <MedicineSafetyItem>[];
    String doctorAdvice = '';

    // Analyze by condition keywords
    final isHeadache = allText.contains('headache') || allText.contains('sir dard') || allText.contains('sar dard') || allText.contains('migraine') || symptoms.contains('headache');
    final isAcidity = allText.contains('acidity') || allText.contains('pet me dard') || allText.contains('gas') || allText.contains('heartburn') || allText.contains('indigestion') || allText.contains('jalan') || symptoms.contains('acidity') || symptoms.contains('vomiting') || symptoms.contains('nausea');
    final isBackPain = allText.contains('back pain') || allText.contains('kamar dard') || allText.contains('peedh dard') || allText.contains('spine') || symptoms.contains('back pain') || symptoms.contains('joint pain');
    final isFatigue = allText.contains('thakan') || allText.contains('weakness') || allText.contains('fatigue') || allText.contains('kamzori') || symptoms.contains('weakness') || symptoms.contains('dizziness');
    final isSleep = allText.contains('neend') || allText.contains('insomnia') || allText.contains('sleep') || allText.contains('tention') || allText.contains('stress');
    final isWeight = allText.contains('weight') || allText.contains('motapa') || allText.contains('vajan') || profile.bmi >= 28;
    final isHighBP = allText.contains('blood pressure') || allText.contains('high bp') || profile.conditions.any((c) => c.toLowerCase().contains('bp') || c.toLowerCase().contains('hypertension'));
    final isFever = allText.contains('fever') || allText.contains('bukhar') || symptoms.contains('fever') || symptoms.contains('cough');

    // Assess duration & severity for Risk Triage
    final isLongDuration = input.duration.contains('1 – 2 weeks') || input.duration.contains('More than a month') || input.duration.contains('hafte') || input.duration.contains('mahine');

    if (isFever && isLongDuration) {
      riskLevel = RiskLevel.consultDoctor;
      riskSummary = 'Persistent fever lasting several days requires professional medical diagnostic tests.';
      recommendedSpecialist = 'General Physician / Internal Medicine';
    } else if (isHighBP || (isBackPain && isLongDuration)) {
      riskLevel = RiskLevel.moderate;
      riskSummary = 'Moderate symptoms. Gentle lifestyle modifications recommended with scheduled doctor review.';
      recommendedSpecialist = isBackPain ? 'Orthopedic / Physiotherapist' : 'Cardiologist / Physician';
    } else if (isLongDuration) {
      riskLevel = RiskLevel.moderate;
      riskSummary = 'Chronic or recurring symptoms should be physically checked by a doctor.';
      recommendedSpecialist = 'General Physician';
    }

    // --- DOMAIN-SPECIFIC GUIDANCE ---
    if (isHeadache) {
      possibleCauses.addAll([
        'Tension headache from prolonged screen time or neck muscle strain',
        'Dehydration or missed regular meals',
        'Inadequate or irregular sleep pattern',
        'Stress, sensory overload, or weather changes',
        'Possible migraine tendency or eye-strain refractive error',
      ]);
      generalTips.addAll([
        'Rest in a quiet, dimly lit, and well-ventilated room.',
        'Place a cool, damp washcloth or gentle warm compress across your forehead and temples.',
        'Drink a large glass of clean water slowly.',
        'Avoid sudden loud noises and take a complete break from digital screens.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Hydration & Magnesium-Rich Foods',
          category: 'Recommended',
          description: 'Electrolyte hydration and light, easily digestible nourishment.',
          items: ['Coconut water or warm herbal tea (chamomile/peppermint)', 'Soaked almonds and pumpkin seeds', 'Fresh watermelon or cucumber slices', 'Light warm vegetable soup'],
          icon: 'water_drop',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Headache Trigger Foods',
          category: 'Limit/Avoid',
          description: 'Common foods that can trigger or worsen vascular headaches.',
          items: ['Excess caffeine or sudden caffeine withdrawal', 'Processed aged cheeses and cured meats', 'Artificial sweeteners and MSG', 'Ice-cold carbonated sodas'],
          icon: 'do_not_disturb',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Shavasana & Anulom Vilom (Alternate Nostril Breathing)',
          duration: '8 – 10 mins',
          intensity: 'Breathing/Relaxation',
          description: 'Calms the nervous system, eases cranial pressure, and reduces mental tension.',
          steps: [
            'Sit comfortably with spine straight or lie down flat.',
            'Close right nostril gently with thumb, inhale deeply through left nostril.',
            'Close left nostril with ring finger, release thumb and exhale smoothly through right.',
            'Repeat for 5 minutes at a calm, unforced pace.',
          ],
          safetyWarning: 'Do not hold your breath forcefully if feeling dizzy.',
        ),
      );
      medList.add(verifiedMedicineDatabase[0]); // Paracetamol
      doctorAdvice =
          'Consult a doctor promptly if your headache is sudden and unusually severe ("thunderclap"), accompanied by neck stiffness, high fever, visual blurriness, vomiting, or confusion.';
    }

    if (isAcidity) {
      possibleCauses.addAll([
        'Gastroesophageal reflux (excess stomach acid irritating food pipe)',
        'Eating spicy, deep-fried, or heavy acidic meals',
        'Irregular meal timings or lying down immediately after eating',
        'Excessive tea, coffee, or smoking',
        'Stress-induced gastric hyperacidity',
      ]);
      generalTips.addAll([
        'Do not lie flat for at least 2 to 3 hours after having a meal.',
        'Eat smaller, frequent meals rather than large, heavy portions.',
        'Elevate the head of your bed by 6 inches while sleeping.',
        'Wear loose, comfortable clothing around your waist.',
      ]);
      foodList.add(
        FoodSuggestion(
          title: 'Soothing Alkaline & High-Fiber Foods',
          category: 'Recommended',
          description: 'Foods that calm the stomach lining and neutralize excess acid.',
          items: [
            'Cold or lukewarm milk (if not lactose intolerant)',
            'Ripe bananas and sweet melons',
            'Oatmeal porridge, boiled rice with light curd/yogurt',
            'Coconut water and fennel (saunf) infused water',
          ],
          icon: 'eco',
          warning: profile.allergies.any((a) => a.toLowerCase().contains('dairy') || a.toLowerCase().contains('milk'))
              ? 'Avoid dairy products due to reported milk allergy; use coconut water and oatmeal instead.'
              : '',
        ),
      );
      foodList.add(
        const FoodSuggestion(
          title: 'Gastric Irritant Foods',
          category: 'Limit/Avoid',
          description: 'Foods known to trigger acid reflux and relax the lower esophageal sphincter.',
          items: ['Deep fried pakoras, samosas, and oily curries', 'Citrus fruits (lemons, oranges, raw tomatoes)', 'Black pepper, red chili powder, raw garlic/onions', 'Carbonated fizzy drinks and strong black coffee'],
          icon: 'block',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Vajrasana (Thunderbolt Pose) after meals',
          duration: '5 – 8 mins',
          intensity: 'Gentle',
          description: 'The only yogic posture recommended directly after meals to enhance digestive blood circulation.',
          steps: [
            'Kneel down on a yoga mat with knees and big toes touching.',
            'Sit back on your heels with palms resting gently on thighs.',
            'Keep spine and neck straight, take slow smooth diaphragmatic breaths.',
          ],
          safetyWarning: 'Avoid if you have severe knee arthritis or acute ankle injury.',
        ),
      );
      medList.add(verifiedMedicineDatabase[1]); // Antacids
      if (doctorAdvice.isEmpty) {
        doctorAdvice =
            'Consult a gastroenterologist if you experience difficulty swallowing, unexplained weight loss, persistent vomiting, black tarry stools, or if acidity symptoms do not improve after 10 days.';
      }
    }

    if (isBackPain) {
      possibleCauses.addAll([
        'Poor sitting posture during prolonged desk or computer work',
        'Muscle strain from lifting heavy objects improperly',
        'Lack of core abdominal and back muscle strength',
        'Unsupportive mattress or sudden awkward twist/bending',
      ]);
      generalTips.addAll([
        'Avoid prolonged continuous sitting; stand up and walk for 2 minutes every 45 minutes.',
        'Apply an ice pack for the first 48 hours for acute muscle strain, followed by mild warmth.',
        'Maintain ergonomic posture with lower back lumbar support.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Anti-Inflammatory Nutrition',
          category: 'Recommended',
          description: 'Nutrients that support bone density, cartilage health, and muscle recovery.',
          items: ['Warm turmeric milk with a pinch of black pepper', 'Leafy green vegetables (spinach, methi)', 'Sesame seeds (til) and walnuts for calcium & omega-3', 'Adequate dietary Vitamin D and sunlight exposure'],
          icon: 'restaurant',
        ),
      );
      yogaList.add(
        YogaExercise(
          title: 'Cat-Cow Stretch (Marjaryasana-Bitilasana) & Bhujangasana',
          duration: '6 – 8 mins',
          intensity: 'Gentle',
          description: 'Gently mobilizes the spinal column, releases lower back stiffness, and strengthens spinal extensors.',
          steps: [
            'Come to all fours with wrists under shoulders and knees under hips.',
            'Inhale: Arch back downward gently, lift chest and gaze up (Cow).',
            'Exhale: Round spine upward toward ceiling, tuck chin toward chest (Cat).',
            'Flow smoothly between positions for 10 breath cycles.',
          ],
          safetyWarning: profile.isPregnant
              ? 'For pregnant patients: Do not compress the belly; keep movements very gentle and perform under prenatal guidance.'
              : 'Stop immediately if you feel sharp, shooting pain down either leg (sciatica sign).',
          doctorConsultRequired: profile.isPregnant || isLongDuration,
        ),
      );
      medList.add(verifiedMedicineDatabase[4]); // Topical Pain Relief & Mild Analgesic
      if (doctorAdvice.isEmpty) {
        doctorAdvice =
            'Seek immediate medical attention if back pain radiates down your leg below the knee, causes numbness/tingling in legs, or is accompanied by bowel/bladder dysfunction.';
      }
    }

    if (isFever) {
      possibleCauses.addAll([
        'Common viral upper respiratory infection (flu/common cold)',
        'Seasonal weather transition reaction',
        'Mild bacterial throat or ear infection',
        'Exertional heat exhaustion or mild dehydration',
      ]);
      generalTips.addAll([
        'Prioritize complete bed rest to allow your immune system to fight infection.',
        'Sponge forehead, neck, and armpits with lukewarm (not cold) water if fever is uncomfortable.',
        'Wear light, breathable cotton clothing.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Hydrating Broths & Vitamin-C Rich Fluids',
          category: 'Recommended',
          description: 'Prevents dehydration and provides easy-to-absorb micronutrients.',
          items: ['Warm khichdi or vegetable dalia with a spoon of ghee', 'Clear vegetable or chicken broth', 'Warm water with lemon and honey', 'Coconut water and pomegranate juice'],
          icon: 'local_drink',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Pranayama (Deep Breathing) & Complete Bed Rest',
          duration: '5 mins',
          intensity: 'Breathing/Relaxation',
          description: 'Rest is paramount during fever. Avoid physical exercise until fully recovered.',
          steps: ['Lie comfortably in bed.', 'Take slow, gentle abdominal breaths without straining.'],
          safetyWarning: 'Strictly avoid intense exercise, cardio, or heavy yoga during active fever.',
        ),
      );
      medList.add(verifiedMedicineDatabase[0]); // Paracetamol
      medList.add(verifiedMedicineDatabase[2]); // ORS
      if (doctorAdvice.isEmpty) {
        doctorAdvice =
            'Consult a doctor if fever rises above 102°F (38.9°C), persists for more than 3 days, or is accompanied by severe rash, stiff neck, or breathing difficulty.';
      }
    }

    if (isFatigue) {
      possibleCauses.addAll([
        'Inadequate rest or physical exhaustion from hectic schedule',
        'Suboptimal nutrition, iron/vitamin D insufficiency',
        'Low fluid and electrolyte balance',
      ]);
      generalTips.addAll([
        'Prioritize 8 hours of uninterrupted restful sleep.',
        'Include iron and protein-rich snacks like roasted chana, dates, and nuts.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Energy & Nutrient Dense Foods',
          category: 'Recommended',
          description: 'Foods that provide sustained vitality without blood sugar spikes.',
          items: ['Soaked dates, raisins, and walnuts', 'Fresh coconut water and lemon water with honey', 'Sprouted moong salad and boiled eggs (or paneer)'],
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Surya Namaskar (Sun Salutations) - 3 Slow Rounds',
          duration: '6 – 8 mins',
          intensity: 'Gentle',
          description: 'Gently elevates metabolic rate, improves blood oxygenation, and banishes sluggishness.',
          steps: ['Perform 3 gentle rounds with coordinated deep breathing.'],
          safetyWarning: 'Stop if feeling dizzy or breathless.',
        ),
      );
    }

    if (isSleep) {
      possibleCauses.addAll([
        'Elevated cortisol and psychological stress',
        'Late-night digital blue light exposure inhibiting melatonin',
        'Irregular sleeping schedule or late dinners',
      ]);
      generalTips.addAll([
        'Establish a digital sunset: turn off screens 45 minutes before sleep.',
        'Keep bedroom dark and slightly cool.',
      ]);
      yogaList.add(
        const YogaExercise(
          title: 'Viparita Karani (Legs-Up-The-Wall Pose)',
          duration: '8 – 10 mins',
          intensity: 'Breathing/Relaxation',
          description: 'Activates the parasympathetic nervous system for deep restorative sleep.',
          steps: ['Lie close to a wall and extend legs straight up against it, resting arms comfortably at your sides.'],
          safetyWarning: 'Avoid during menstruation if causing discomfort.',
        ),
      );
    }

    if (isWeight) {
      possibleCauses.addAll([
        'Sedentary lifestyle with low daily step count',
        'High intake of refined sugars and processed carbohydrates',
      ]);
      generalTips.addAll([
        'Aim for at least 8,000 to 10,000 steps of brisk walking daily.',
        'Drink a glass of water 20 minutes before every major meal.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'High Fiber & Low Glycemic Foods',
          category: 'Recommended',
          description: 'Assists in healthy satiety and sustained metabolic burn.',
          items: ['Raw salad before meals (cucumber, carrots, beetroot)', 'Whole pulses and millets (jowar, bajra, ragi)', 'Green tea without sugar'],
        ),
      );
    }

    // Default general wellness if input was brief
    if (possibleCauses.isEmpty) {
      possibleCauses.addAll([
        'Lifestyle factors such as daily routine stress, physical fatigue, or irregular rest',
        'Mild seasonal transition or minor dietary adjustment needed',
        'General muscular or postural strain',
      ]);
      generalTips.addAll([
        'Maintain a consistent daily sleep schedule (7–8 hours nightly).',
        'Stay well-hydrated throughout the day.',
        'Incorporate 20–30 minutes of gentle daily walking or stretching.',
      ]);
      foodList.add(
        const FoodSuggestion(
          title: 'Balanced Wholesome Diet',
          category: 'Recommended',
          description: 'Fresh seasonal fruits, vegetables, whole grains, and clean hydration.',
          items: ['Fresh seasonal fruits and green vegetables', 'Whole grain rotis/rice and lentils (dal)', 'Adequate clean drinking water (8-10 glasses)'],
          icon: 'restaurant',
        ),
      );
      yogaList.add(
        const YogaExercise(
          title: 'Daily Gentle Walking & Morning Stretches',
          duration: '15 – 20 mins',
          intensity: 'Gentle',
          description: 'Boosts circulation, improves joint mobility, and elevates mood.',
          steps: ['Take a brisk, comfortable morning walk in fresh air.', 'Perform gentle neck, shoulder, and ankle rotations.'],
        ),
      );
      medList.add(verifiedMedicineDatabase[0]);
    }

    // General Lifestyle suggestions
    lifestyleTips.addAll([
      'Hydration: Drink 2.5 to 3 liters of water across the day unless medically restricted.',
      'Sleep Hygiene: Avoid mobile screens 45 minutes before bedtime for restorative deep sleep.',
      'Daily Movement: Aim for at least 6,000 to 8,000 steps of comfortable walking.',
      'Stress Reduction: Practice 5 minutes of deep mindfulness or mindful breathing daily.',
    ]);

    if (medList.isEmpty) {
      medList.add(verifiedMedicineDatabase[0]); // General Safe Analgesic Overview
    }

    if (doctorAdvice.isEmpty) {
      doctorAdvice =
          'If your symptoms worsen, do not improve within a few days, or if you feel uncertain about your condition, consult a licensed healthcare professional for an in-person physical evaluation.';
    }

    return HealthGuidanceResult(
      id: 'result-${_uuid.v4().substring(0, 8)}',
      reportedProblem: input.mainProblem.isNotEmpty ? input.mainProblem : 'General Health Assessment',
      symptoms: input.symptoms,
      duration: input.duration,
      riskLevel: riskLevel,
      riskSummary: riskSummary,
      possibleCauses: possibleCauses,
      generalGuidanceTips: generalTips,
      foodSuggestions: foodList,
      yogaExercises: yogaList,
      lifestyleTips: lifestyleTips,
      medicineSafetyItems: medList,
      doctorConsultationAdvice: doctorAdvice,
      recommendedSpecialist: recommendedSpecialist,
      isEmergency: false,
      emergencyRedFlags: const [],
      createdAt: DateTime.now(),
    );
  }

  static HealthGuidanceResult _buildEmergencyResult(HealthCheckInput input, List<String> triggers) {
    return HealthGuidanceResult(
      id: 'emergency-${_uuid.v4().substring(0, 8)}',
      reportedProblem: input.mainProblem,
      symptoms: input.symptoms,
      duration: input.duration,
      riskLevel: RiskLevel.emergency,
      riskSummary: 'URGENT: Red-flag symptoms detected that warrant immediate emergency medical intervention.',
      possibleCauses: [
        'Acute cardiovascular, respiratory, or neurological medical emergency',
        'Severe acute physiological distress requiring hospital evaluation',
      ],
      disclaimerNote:
          '🚨 EMERGENCY ALERT: Do not wait or attempt self-treatment at home. Contact local emergency medical services (112 / 108 / 911) or visit the nearest emergency room immediately.',
      generalGuidanceTips: [
        'Stay calm, sit or lie down in a safe, comfortable position with open ventilation.',
        'Do NOT exert yourself physically.',
        'Inform a family member, neighbor, or caregiver immediately.',
        'Call local emergency services (112 / 108 / 911) without delay.',
      ],
      foodSuggestions: const [
        FoodSuggestion(
          title: 'Emergency Protocol',
          category: 'Limit/Avoid',
          description: 'Do not eat heavy meals or drink large volumes while awaiting emergency medical care.',
          items: ['Avoid solid food until evaluated by an emergency doctor', 'Take small sips of water only if completely conscious and not choking'],
          icon: 'warning',
        ),
      ],
      yogaExercises: const [
        YogaExercise(
          title: 'Absolute Rest — No Physical Exercise',
          duration: 'Immediate',
          intensity: 'Breathing/Relaxation',
          description: 'Physical exertion is strictly contraindicated during an acute medical emergency.',
          steps: ['Sit comfortably with back supported and breathe as calmly as possible while awaiting medical help.'],
          safetyWarning: 'Do NOT perform any yoga, stretches, or physical exertion.',
          doctorConsultRequired: true,
        ),
      ],
      lifestyleTips: const [
        'Keep your identification, health insurance card, and current medicine list ready for hospital staff.',
        'Ensure the front door is unlocked if you are alone so responders can enter.',
      ],
      medicineSafetyItems: const [
        MedicineSafetyItem(
          id: 'med-emergency-warning',
          name: 'Emergency Medication Caution',
          genericCategory: 'Critical Safety Protocol',
          generalPurpose: 'Do not self-medicate or take unprescribed drugs during an acute emergency.',
          commonPrecautions: ['Emergency doctors must evaluate vital signs before administering medication.'],
          commonSideEffects: ['Self-medicating can mask vital diagnostic signs.'],
          whoShouldAskDoctor: ['All patients in emergency situations.'],
          mandatoryWarning: '⚠️ Do not take random medicines without direct instructions from emergency medical staff.',
        ),
      ],
      doctorConsultationAdvice:
          '🚨 IMMEDIATE MEDICAL CARE REQUIRED: Please call emergency services (112 / 108 / 911) or reach the nearest hospital casualty/emergency room immediately.',
      recommendedSpecialist: 'Emergency Medicine / Acute Care Hospital',
      isEmergency: true,
      emergencyRedFlags: triggers,
      createdAt: DateTime.now(),
    );
  }
}
