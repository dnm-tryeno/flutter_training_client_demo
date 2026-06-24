import 'package:flutter/material.dart';

import '../theme.dart';

class _Message {
  final String text;
  final bool isMe;
  final String time;
  const _Message(this.text, this.isMe, this.time);
}

const _messages = <_Message>[
  _Message('Hey!', false, '10:30'),
  _Message('Hi, what\'s up?', true, '10:31'),
  _Message('Did you finish the Flutter task?', false, '10:32'),
  _Message('Almost done, just polishing the UI', true, '10:33'),
  _Message('Nice 🔥 send me a screenshot when ready', false, '10:35'),
  _Message('Sure!', true, '10:36'),
  _Message('btw the launcher idea is great', false, '10:42'),
];

class ChatDetailPage extends StatelessWidget {
  final String name;
  final Color avatar;
  const ChatDetailPage({super.key, required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundColor: avatar, radius: 18),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16)),
                const Text('online',
                    style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam),
          SizedBox(width: 16),
          Icon(Icons.call),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _Bubble(message: _messages[i]),
            ),
          ),
          _Composer(),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Message message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? ChatColors.myBubble : ChatColors.theirBubble,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.text,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message.time,
                    style: Theme.of(context).textTheme.bodySmall),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all,
                      size: 14, color: Colors.lightBlue),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.attach_file, color: Colors.grey),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: ChatColors.primary,
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
