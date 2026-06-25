import 'package:flutter/material.dart';

import 'pages/chat_list_page.dart';
import 'theme.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: chatTheme,
      home: const ChatListPage(),
    );
  }
}
