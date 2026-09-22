import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import '../models/health_history_record.dart';
import '../models/health_guidance_result.dart';
import '../models/health_check_input.dart';
import '../models/ai_chat_message.dart';
import '../models/admin_models.dart';
import '../localization/app_language.dart';
import '../services/storage_service.dart';
import '../services/health_suggestion_engine.dart';
import '../services/ai_health_assistant_service.dart';

class CarePlusState extends ChangeNotifier {
  static const _uuid = Uuid();

  // App Settings State
  bool _isInitialized = false;
  bool _isDisclaimerAccepted = false;
  AppLanguage _language = AppLanguage.hinglish;
  bool _isDarkMode = false;
  bool _isElderlyMode = false;
  String _emergencyNumber = '112';

  // User Profile & History
  UserProfile _userProfile = UserProfile.defaultProfile();
  List<HealthHistoryRecord> _history = [];
  HealthGuidanceResult? _currentResult;
  HealthCheckInput? _lastInput;

  // AI Assistant Chat State
  List<AIChatMessage> _chatMessages = [];
  bool _isAIThinking = false;

  // Admin CMS State
  late AdminContentState _adminContent;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isDisclaimerAccepted => _isDisclaimerAccepted;
  AppLanguage get language => _language;
  bool get isDarkMode => _isDarkMode;
  bool get isElderlyMode => _isElderlyMode;
  double get fontScale => _isElderlyMode ? 1.25 : 1.0;
  String get emergencyNumber => _emergencyNumber;
  UserProfile get userProfile => _userProfile;
  List<HealthHistoryRecord> get history => _history;
  HealthGuidanceResult? get currentResult => _currentResult;
  HealthCheckInput? get lastInput => _lastInput;
  List<AIChatMessage> get chatMessages => _chatMessages;
  bool get isAIThinking => _isAIThinking;
  AdminContentState get adminContent => _adminContent;

  CarePlusState() {
    _initAdminDefaults();
    initialize();
  }

  void _initAdminDefaults() {
    _adminContent = AdminContentState(
      medicines: List.from(HealthSuggestionEngine.verifiedMedicineDatabase),
      foods: const [],
      yogaRoutines: const [],
      aiSystemPrompt:
          'You are CarePlus AI, a supportive and safe health companion. Provide general educational guidance. Never prescribe medicines, never give exact dosages, and detect emergency symptoms immediately.',
      emergencyNumber: '112',
      disclaimerText: AppStrings.get('disclaimer_text', AppLanguage.hinglish),
    );
  }

  Future<void> initialize() async {
    _isDisclaimerAccepted = await StorageService.isDisclaimerAccepted();
    _userProfile = await StorageService.loadUserProfile();
    _history = await StorageService.loadHistory();
    _language = await StorageService.loadLanguage();
    _isDarkMode = await StorageService.loadDarkMode();
    _isElderlyMode = await StorageService.loadElderlyMode();
    _emergencyNumber = await StorageService.loadEmergencyNumber();
    _chatMessages = AIHealthAssistantService.getInitialMessages(_language);

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> acceptDisclaimer() async {
    _isDisclaimerAccepted = true;
    await StorageService.setDisclaimerAccepted(true);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    await StorageService.saveLanguage(lang);
    _chatMessages = AIHealthAssistantService.getInitialMessages(lang);
    if (_lastInput != null) {
      _currentResult = HealthSuggestionEngine.analyze(_lastInput!, language: lang);
    }
    _adminContent = _adminContent.copyWith(
      medicines: List.from(HealthSuggestionEngine.getVerifiedMedicineDatabase(lang)),
      disclaimerText: AppStrings.get('disclaimer_text', lang),
    );
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    await StorageService.saveDarkMode(isDark);
    notifyListeners();
  }

  Future<void> toggleElderlyMode(bool isElderly) async {
    _isElderlyMode = isElderly;
    await StorageService.saveElderlyMode(isElderly);
    notifyListeners();
  }

  Future<void> updateEmergencyNumber(String num) async {
    _emergencyNumber = num;
    _adminContent = _adminContent.copyWith(emergencyNumber: num);
    await StorageService.saveEmergencyNumber(num);
    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    _userProfile = profile;
    await StorageService.saveUserProfile(profile);
    notifyListeners();
  }

  Future<HealthGuidanceResult> runHealthCheck(HealthCheckInput input) async {
    _lastInput = input;
    // Update profile if changed during flow
    await updateUserProfile(input.profile);

    final result = HealthSuggestionEngine.analyze(input, language: _language);
    _currentResult = result;

    // Save into history
    final record = HealthHistoryRecord(
      id: 'rec-${_uuid.v4().substring(0, 8)}',
      date: DateTime.now(),
      reportedProblem: result.reportedProblem,
      symptoms: result.symptoms,
      riskLevel: result.riskLevel,
      doctorRecommendation: result.doctorConsultationAdvice,
      guidanceResult: result,
      input: input,
    );

    await StorageService.saveHistoryRecord(record);
    _history.insert(0, record);

    notifyListeners();
    return result;
  }

  void setCurrentResult(HealthGuidanceResult result, HealthCheckInput input) {
    _currentResult = result;
    _lastInput = input;
    notifyListeners();
  }

  Future<void> deleteHistoryItem(String id) async {
    await StorageService.deleteHistoryRecord(id);
    _history.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> clearAllHealthData() async {
    await StorageService.clearAllData();
    _history.clear();
    _userProfile = UserProfile.defaultProfile();
    _currentResult = null;
    _lastInput = null;
    notifyListeners();
  }

  // AI Assistant Chat actions
  void sendUserChatMessage(String query) {
    if (query.trim().isEmpty) return;

    final userMsg = AIChatMessage(
      id: 'usr-${_uuid.v4().substring(0, 8)}',
      text: query.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    _chatMessages.add(userMsg);
    _isAIThinking = true;
    notifyListeners();

    // Simulate safe conversational AI inference delay
    Future.delayed(const Duration(milliseconds: 650), () {
      final aiResponse = AIHealthAssistantService.processUserQuery(query, _language);
      _chatMessages.add(aiResponse);
      _isAIThinking = false;
      notifyListeners();
    });
  }

  void clearChatMessages() {
    _chatMessages = AIHealthAssistantService.getInitialMessages(_language);
    notifyListeners();
  }

  // Admin Actions
  void updateAdminContent(AdminContentState state) {
    _adminContent = state;
    notifyListeners();
  }

  // Helper string translation
  String tr(String key) => AppStrings.get(key, _language);
}

// InheritedProvider widget for CarePlus State
class CarePlusStateScope extends InheritedNotifier<CarePlusState> {
  const CarePlusStateScope({
    super.key,
    required CarePlusState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CarePlusState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CarePlusStateScope>();
    if (scope == null || scope.notifier == null) {
      throw StateError('CarePlusStateScope not found in context.');
    }
    return scope.notifier!;
  }
}
