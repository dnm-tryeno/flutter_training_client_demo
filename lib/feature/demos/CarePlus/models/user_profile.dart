class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender; // 'Male', 'Female', 'Other'
  final double heightCm;
  final double weightKg;
  final String location;
  final List<String> conditions;
  final List<String> allergies;
  final List<String> currentMedications;
  final bool isPregnant;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.location = '',
    this.conditions = const [],
    this.allergies = const [],
    this.currentMedications = const [],
    this.isPregnant = false,
  });

  double get bmi {
    if (heightCm <= 0 || weightKg <= 0) return 0.0;
    final heightMeters = heightCm / 100.0;
    return double.parse((weightKg / (heightMeters * heightMeters)).toStringAsFixed(1));
  }

  String get bmiCategory {
    final b = bmi;
    if (b <= 0) return 'Unknown';
    if (b < 18.5) return 'Underweight';
    if (b < 25.0) return 'Normal Weight';
    if (b < 30.0) return 'Overweight';
    return 'Obese';
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? location,
    List<String>? conditions,
    List<String>? allergies,
    List<String>? currentMedications,
    bool? isPregnant,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      location: location ?? this.location,
      conditions: conditions ?? this.conditions,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      isPregnant: isPregnant ?? this.isPregnant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'location': location,
      'conditions': conditions,
      'allergies': allergies,
      'currentMedications': currentMedications,
      'isPregnant': isPregnant,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user-1',
      name: json['name'] as String? ?? 'Guest User',
      age: (json['age'] as num?)?.toInt() ?? 30,
      gender: json['gender'] as String? ?? 'Male',
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 170.0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 68.0,
      location: json['location'] as String? ?? '',
      conditions: (json['conditions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      currentMedications: (json['currentMedications'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      isPregnant: json['isPregnant'] as bool? ?? false,
    );
  }

  static UserProfile defaultProfile() {
    return const UserProfile(
      id: 'default-patient',
      name: 'Rohan Sharma',
      age: 32,
      gender: 'Male',
      heightCm: 172.0,
      weightKg: 70.0,
      location: 'New Delhi',
      conditions: [],
      allergies: [],
      currentMedications: [],
      isPregnant: false,
    );
  }
}
