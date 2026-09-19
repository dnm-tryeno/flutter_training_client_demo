import 'package:flutter/material.dart';

import '../demos/CarePlus/care_plus_app.dart';
import '../demos/Learning Management System (LMS)/lms_app.dart';
import '../demos/chat/chat_app.dart';
import '../demos/instagram/instagram_app.dart';
import '../demos/tiktok/tiktok_app.dart';
import '../Voice Chat Room/voice_chat_app.dart';
import 'demo_entry.dart';

final List<DemoEntry> demos = [
  DemoEntry(
    title: 'CarePlus',
    subtitle: 'Health Guidance Companion',
    icon: Icons.health_and_safety_rounded,
    tileColor: Color(0xFF0D9488),
    builder: (_) => const CarePlusApp(),
  ),
  DemoEntry(
    title: 'VibeRoom',
    subtitle: 'Voice Social & Party',
    icon: Icons.graphic_eq_rounded,
    tileColor: Color(0xFF6C3BFF),
    builder: (_) => const VoiceChatApp(),
  ),
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
