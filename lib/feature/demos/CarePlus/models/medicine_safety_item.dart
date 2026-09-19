class MedicineSafetyItem {
  final String id;
  final String name;
  final String genericCategory;
  final String generalPurpose;
  final List<String> commonPrecautions;
  final List<String> commonSideEffects;
  final List<String> importantInteractions;
  final List<String> whoShouldAskDoctor;
  final String mandatoryWarning;
  final String sourceReference;
  final String lastReviewedDate;
  final String medicalReviewer;

  const MedicineSafetyItem({
    required this.id,
    required this.name,
    required this.genericCategory,
    required this.generalPurpose,
    required this.commonPrecautions,
    required this.commonSideEffects,
    this.importantInteractions = const [],
    required this.whoShouldAskDoctor,
    this.mandatoryWarning =
        '⚠️ Important: Koi bhi medicine lene, band karne ya dose change karne se pehle doctor ya qualified healthcare professional se salah lein.',
    this.sourceReference = 'WHO Essential Medicines / Clinical Guidelines',
    this.lastReviewedDate = 'September 2026',
    this.medicalReviewer = 'CarePlus Medical Editorial Board',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'genericCategory': genericCategory,
    'generalPurpose': generalPurpose,
    'commonPrecautions': commonPrecautions,
    'commonSideEffects': commonSideEffects,
    'importantInteractions': importantInteractions,
    'whoShouldAskDoctor': whoShouldAskDoctor,
    'mandatoryWarning': mandatoryWarning,
    'sourceReference': sourceReference,
    'lastReviewedDate': lastReviewedDate,
    'medicalReviewer': medicalReviewer,
  };

  factory MedicineSafetyItem.fromJson(Map<String, dynamic> json) => MedicineSafetyItem(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    genericCategory: json['genericCategory'] as String? ?? '',
    generalPurpose: json['generalPurpose'] as String? ?? '',
    commonPrecautions: (json['commonPrecautions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    commonSideEffects: (json['commonSideEffects'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    importantInteractions: (json['importantInteractions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    whoShouldAskDoctor: (json['whoShouldAskDoctor'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    mandatoryWarning: json['mandatoryWarning'] as String? ?? '',
    sourceReference: json['sourceReference'] as String? ?? 'WHO Guidelines',
    lastReviewedDate: json['lastReviewedDate'] as String? ?? '2026',
    medicalReviewer: json['medicalReviewer'] as String? ?? 'Medical Board',
  );
}
