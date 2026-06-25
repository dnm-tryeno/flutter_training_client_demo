import 'package:flutter/material.dart';

class DemoEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tileColor;
  final WidgetBuilder builder;

  const DemoEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tileColor,
    required this.builder,
  });
}
