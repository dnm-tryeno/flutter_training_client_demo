import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String titleHindi;
  final String titleEnglish;
  final String shortDesc;
  final String detailedDesc;
  final int iconCodePoint;
  final int accentColorValue;
  final List<String> subOfferings;
  final List<String> benefits;

  const ServiceModel({
    required this.id,
    required this.titleHindi,
    required this.titleEnglish,
    required this.shortDesc,
    required this.detailedDesc,
    required this.iconCodePoint,
    this.accentColorValue = 0xFF6366F1,
    required this.subOfferings,
    required this.benefits,
  });

  // ignore: non_const_argument_for_const_parameter
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get accentColor => Color(accentColorValue);

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleHindi': titleHindi,
        'titleEnglish': titleEnglish,
        'shortDesc': shortDesc,
        'detailedDesc': detailedDesc,
        'iconCodePoint': iconCodePoint,
        'accentColorValue': accentColorValue,
        'subOfferings': subOfferings,
        'benefits': benefits,
      };

  factory ServiceModel.fromJson(Map<String, dynamic> json, {IconData fallbackIcon = Icons.miscellaneous_services_rounded}) {
    return ServiceModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titleHindi: json['titleHindi'] as String? ?? '',
      titleEnglish: json['titleEnglish'] as String? ?? '',
      shortDesc: json['shortDesc'] as String? ?? '',
      detailedDesc: json['detailedDesc'] as String? ?? '',
      iconCodePoint: json['iconCodePoint'] as int? ?? fallbackIcon.codePoint,
      accentColorValue: json['accentColorValue'] as int? ?? 0xFF6366F1,
      subOfferings: List<String>.from(json['subOfferings'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  ServiceModel copyWith({
    String? id,
    String? titleHindi,
    String? titleEnglish,
    String? shortDesc,
    String? detailedDesc,
    int? iconCodePoint,
    int? accentColorValue,
    List<String>? subOfferings,
    List<String>? benefits,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      titleHindi: titleHindi ?? this.titleHindi,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      shortDesc: shortDesc ?? this.shortDesc,
      detailedDesc: detailedDesc ?? this.detailedDesc,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      accentColorValue: accentColorValue ?? this.accentColorValue,
      subOfferings: subOfferings ?? this.subOfferings,
      benefits: benefits ?? this.benefits,
    );
  }
}
