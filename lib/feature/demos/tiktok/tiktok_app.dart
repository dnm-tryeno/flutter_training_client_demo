import 'package:flutter/material.dart';

import 'pages/tiktok_feed_page.dart';
import 'theme.dart';

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tikTokTheme,
      home: const TikTokFeedPage(),
    );
  }
}
