import 'package:flutter/material.dart';

import '../lms_data.dart';
import '../theme.dart';

/// Chat list with 1:1 mentor chats and group chats, plus a simple
/// conversation screen.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sampleChats.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 76),
      itemBuilder: (_, i) {
        final c = sampleChats[i];
        return ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => _ChatRoom(thread: c)),
          ),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: c.color.withValues(alpha: 0.15),
            child: Icon(c.isGroup ? Icons.groups : Icons.person,
                color: c.color),
          ),
          title: Text(c.name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(c.lastMessage,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(c.time,
                  style: const TextStyle(
                      color: LmsColors.textSecondary, fontSize: 11)),
              const SizedBox(height: 6),
              if (c.unread > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: LmsColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text('${c.unread}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                )
              else
                const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _ChatRoom extends StatelessWidget {
  final ChatThread thread;
  const _ChatRoom({required this.thread});

  @override
  Widget build(BuildContext context) {
    final messages = <_Msg>[
      _Msg('Hi sir, I have a doubt in Article 32.', false),
      _Msg('Sure, go ahead. Which part is unclear?', true),
      _Msg('Difference between writ jurisdiction of SC vs HC.', false),
      _Msg('Great question! Art 32 is for FR only, Art 226 is wider.',
          true),
      _Msg('Got it, thank you! 🙏', false),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: thread.color.withValues(alpha: 0.15),
              child: Icon(thread.isGroup ? Icons.groups : Icons.person,
                  color: thread.color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(thread.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [for (final m in messages) _bubble(m)],
            ),
          ),
          _composer(context),
        ],
      ),
    );
  }

  Widget _bubble(_Msg m) {
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: m.mine ? LmsColors.primary : LmsColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LmsColors.divider),
        ),
        child: Text(m.text,
            style: TextStyle(
                color: m.mine ? Colors.white : LmsColors.textPrimary)),
      ),
    );
  }

  Widget _composer(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          color: LmsColors.surface,
          border: Border(top: BorderSide(color: LmsColors.divider)),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline,
                color: LmsColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: 44,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: LmsColors.background,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text('Type a message…',
                    style: TextStyle(color: LmsColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: LmsColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo — message not sent')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool mine;
  _Msg(this.text, this.mine);
}
