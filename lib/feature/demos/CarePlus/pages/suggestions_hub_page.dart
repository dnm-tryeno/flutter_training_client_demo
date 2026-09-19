import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/care_plus_state.dart';
import '../services/health_suggestion_engine.dart';
import '../models/food_suggestion.dart';
import '../models/yoga_exercise.dart';
import '../widgets/food_card.dart';
import '../widgets/yoga_card.dart';
import '../widgets/medicine_safety_card.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/section_header.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/language_selector_button.dart';

class SuggestionsHubPage extends StatefulWidget {
  const SuggestionsHubPage({super.key});

  @override
  State<SuggestionsHubPage> createState() => _SuggestionsHubPageState();
}

class _SuggestionsHubPageState extends State<SuggestionsHubPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<FoodSuggestion> generalFoods = [
    FoodSuggestion(
      title: 'Digestive & Gut Health Nutrition',
      category: 'Recommended',
      description: 'Foods that support gut microbiome, prevent constipation, and balance gastric acid.',
      items: [
        'Probiotic rich plain curd / yogurt',
        'Fennel seeds (saunf) and cumin (jeera) water',
        'High-fiber oats, ripe bananas, and papaya',
        'Steamed moong dal khichdi with a dash of ghee',
      ],
      icon: 'eco',
    ),
    FoodSuggestion(
      title: 'High Acidity & Bloating Triggers',
      category: 'Limit/Avoid',
      description: 'Foods known to aggravate stomach lining and slow down gastric emptying.',
      items: [
        'Excessively spicy and deep-fried savory snacks',
        'Over-fermented or ultra-processed bakery goods',
        'Carbonated soft drinks and commercial fruit punches',
        'Strong black tea/coffee on an empty stomach',
      ],
      icon: 'block',
    ),
  ];

  static const List<YogaExercise> generalYoga = [
    YogaExercise(
      title: 'Tadasana (Mountain Pose) & Gentle Neck Release',
      duration: '5 – 8 mins',
      intensity: 'Gentle',
      description: 'Improves spinal alignment, corrects desk posture, and reduces tension in upper trapezius muscles.',
      steps: [
        'Stand tall with feet hip-width apart and arms by your sides.',
        'Inhale, interlock fingers and reach arms overhead towards the sky.',
        'Gently roll neck in smooth half-circles to release cervical stiffness.',
      ],
      safetyWarning: 'Avoid over-extending neck backwards if you suffer from vertigo.',
    ),
    YogaExercise(
      title: 'Anulom Vilom (Alternate Nostril Breathing)',
      duration: '8 – 10 mins',
      intensity: 'Breathing/Relaxation',
      description: 'Harmonizes both hemispheres of the brain, calms rapid heart rate, and relieves mental fatigue.',
      steps: [
        'Sit comfortably with spine straight.',
        'Inhale smoothly through left nostril for 4 counts while closing right.',
        'Exhale through right nostril for 4 counts, then inhale right and exhale left.',
      ],
      safetyWarning: 'Practice gently without forceful breath retention.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = CarePlusStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.tr('nav_suggestions'),
          style: TextStyle(fontSize: 18 * state.fontScale, fontWeight: FontWeight.w700),
        ),
        actions: const [
          LanguageSelectorButton(),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: TextStyle(fontSize: 13.5 * state.fontScale, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Food & Nutrition'),
            Tab(text: 'Yoga & Movement'),
            Tab(text: 'Medicine Safety'),
            Tab(text: 'Lifestyle Habits'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Food
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Nutrition & Diet Library',
                    subtitle: 'Wholesome evidence-based dietary recommendations',
                    icon: Icons.restaurant_rounded,
                  ),
                  ...generalFoods.map((f) => FoodCard(food: f)),
                  const SizedBox(height: 16),
                  const DisclaimerBanner(compact: true),
                ],
              ),
            ),

            // Tab 2: Yoga
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Gentle Yoga & Breathing Library',
                    subtitle: 'Beginner-friendly postures with safety guidelines',
                    icon: Icons.self_improvement_rounded,
                  ),
                  ...generalYoga.map((y) => YogaCard(yoga: y)),
                  const SizedBox(height: 16),
                  const DisclaimerBanner(compact: true),
                ],
              ),
            ),

            // Tab 3: Medicine Safety
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Educational Medicine Directory',
                    subtitle: 'Verified precautions and safety interactions',
                    icon: Icons.medication_rounded,
                  ),
                  ...HealthSuggestionEngine.verifiedMedicineDatabase.map((m) => MedicineSafetyCard(medicine: m)),
                  const SizedBox(height: 16),
                  const DisclaimerBanner(compact: true),
                ],
              ),
            ),

            // Tab 4: Lifestyle
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Daily Preventive Lifestyle Routines',
                    subtitle: 'Small consistent habits for lasting vitality',
                    icon: Icons.spa_rounded,
                  ),
                  const SuggestionCard(
                    title: 'Optimal Sleep Hygiene',
                    description: 'Quality deep sleep restores cognitive function and regulates metabolic hormones.',
                    icon: Icons.bedtime_outlined,
                    bulletPoints: [
                      'Maintain a fixed sleep and wake-up time every single day.',
                      'Turn off blue-light screens at least 45 minutes before sleep.',
                      'Keep the bedroom cool, dark, and well-ventilated.',
                    ],
                  ),
                  const SuggestionCard(
                    title: 'Hydration Strategy',
                    description: 'Adequate hydration keeps mucosal barriers intact and aids digestive health.',
                    icon: Icons.water_drop_outlined,
                    bulletPoints: [
                      'Drink 1 glass of lukewarm water first thing upon waking up.',
                      'Spread 2.5 to 3 liters evenly throughout the daytime.',
                      'Reduce heavy water intake 1 hour before sleeping to avoid night awakenings.',
                    ],
                  ),
                  const SizedBox(height: 16),
                  const DisclaimerBanner(compact: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
