import 'package:flutter/material.dart';

class WhyWorkModel {
  final String id;
  final String title;
  final String subtitleHindi;
  final int iconCodePoint;
  final int colorValue;

  const WhyWorkModel({
    required this.id,
    required this.title,
    required this.subtitleHindi,
    required this.iconCodePoint,
    required this.colorValue,
  });

  // ignore: non_const_argument_for_const_parameter
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitleHindi': subtitleHindi,
        'iconCodePoint': iconCodePoint,
        'colorValue': colorValue,
      };

  factory WhyWorkModel.fromJson(Map<String, dynamic> json) {
    return WhyWorkModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      subtitleHindi: json['subtitleHindi'] as String? ?? '',
      iconCodePoint: json['iconCodePoint'] as int? ?? Icons.star_rounded.codePoint,
      colorValue: json['colorValue'] as int? ?? 0xFF6366F1,
    );
  }

  WhyWorkModel copyWith({
    String? id,
    String? title,
    String? subtitleHindi,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return WhyWorkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitleHindi: subtitleHindi ?? this.subtitleHindi,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
