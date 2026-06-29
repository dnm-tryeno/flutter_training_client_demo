import 'package:flutter/material.dart';

import '../demos/Learning Management System (LMS)/lms_app.dart';
import '../demos/chat/chat_app.dart';
import '../demos/instagram/instagram_app.dart';
import '../demos/tiktok/tiktok_app.dart';
import 'demo_entry.dart';

final List<DemoEntry> demos = [
  DemoEntry(
    title: 'LMS',
    subtitle: 'Learning Management System',
    icon: Icons.school,
    tileColor: Color(0xFF16A34A),
    builder: (_) => const LmsApp(),
  ),
  DemoEntry(
    title: 'TikTok',
    subtitle: 'Vertical video feed',
    icon: Icons.music_video,
    tileColor: Color(0xFFFE2C55),
    builder: (_) => const TikTokApp(),
  ),
  DemoEntry(
    title: 'Instagram',
    subtitle: 'Photo feed + stories',
    icon: Icons.camera_alt,
    tileColor: Color(0xFFE1306C),
    builder: (_) => const InstagramApp(),
  ),
  DemoEntry(
    title: 'Chat',
    subtitle: 'WhatsApp-style chat',
    icon: Icons.chat_bubble,
    tileColor: Color(0xFF25D366),
    builder: (_) => const ChatApp(),
  ),
];
