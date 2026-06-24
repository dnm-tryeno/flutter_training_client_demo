import 'package:flutter/material.dart';

import '../theme.dart';
import 'chat_detail_page.dart';

class _ChatPreview {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final Color avatar;

  const _ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.avatar,
  });
}

const _chats = <_ChatPreview>[
  _ChatPreview(
    name: 'Anita',
    lastMessage: 'Hey, did you finish the Flutter task?',
    time: '10:42',
    unread: 2,
    avatar: Color(0xFFFFB6C1),
  ),
  _ChatPreview(
    name: 'DNM Team',
    lastMessage: 'Standup in 10 min',
    time: '09:30',
    unread: 5,
    avatar: Color(0xFF87CEEB),
  ),
  _ChatPreview(
    name: 'Rahul',
    lastMessage: 'thanks 🙏',
    time: 'Yesterday',
    unread: 0,
    avatar: Color(0xFFFFD700),
  ),
  _ChatPreview(
    name: 'Jinal',
    lastMessage: 'See you tomorrow!',
    time: 'Yesterday',
    unread: 0,
    avatar: Color(0xFF98FB98),
  ),
];

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        itemCount: _chats.length,
        separatorBuilder: (_, __) => const Divider(height: 0, indent: 72),
        itemBuilder: (context, i) {
          final c = _chats[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: c.avatar,
              child: Text(c.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            title: Text(c.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(c.lastMessage,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.time,
                    style: TextStyle(
                      fontSize: 11,
                      color: c.unread > 0
                          ? ChatColors.accent
                          : ChatColors.subtle,
                    )),
                const SizedBox(height: 4),
                if (c.unread > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: ChatColors.accent,
                    child: Text('${c.unread}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        )),
                  ),
              ],
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatDetailPage(name: c.name, avatar: c.avatar),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ChatColors.accent,
        onPressed: () {},
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
