import 'package:flutter/material.dart';

import 'pages/instagram_feed_page.dart';
import 'theme.dart';

class InstagramApp extends StatelessWidget {
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: instagramTheme,
      home: const InstagramFeedPage(),
    );
  }
}
