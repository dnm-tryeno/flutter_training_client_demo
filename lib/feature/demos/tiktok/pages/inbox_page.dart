import 'package:flutter/material.dart';

class _Notif {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String detail;
  final String time;
  const _Notif(this.icon, this.iconBg, this.title, this.detail, this.time);
}

const _notifs = <_Notif>[
  _Notif(Icons.favorite, Color(0xFFFE2C55), 'anita liked your video',
      '"Building TikTok in Flutter 🚀"', '2h'),
  _Notif(Icons.person_add, Color(0xFF25F4EE), 'dnm started following you',
      'Tap to follow back', '4h'),
  _Notif(Icons.comment, Color(0xFFFFB300), 'rahul commented',
      '"Tutorial please!"', '5h'),
  _Notif(Icons.live_tv, Color(0xFFE91E63), 'jinal went live',
      'Tap to join the stream', '6h'),
  _Notif(Icons.favorite, Color(0xFFFE2C55), 'vishal and 24 others liked',
      '"My first Flutter app!"', '1d'),
  _Notif(Icons.share, Color(0xFF4CAF50), 'Your video was shared 12 times',
      'Keep posting!', '2d'),
];

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Inbox',
            style: TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                _IconBubble(icon: Icons.person_add, label: 'Follows'),
                SizedBox(width: 12),
                _IconBubble(icon: Icons.favorite, label: 'Likes'),
                SizedBox(width: 12),
                _IconBubble(icon: Icons.comment, label: 'Comments'),
                SizedBox(width: 12),
                _IconBubble(icon: Icons.alternate_email, label: 'Mentions'),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _notifs.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white12, height: 0, indent: 72),
        itemBuilder: (context, i) {
          final n = _notifs[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: n.iconBg,
              child: Icon(n.icon, color: Colors.white, size: 20),
            ),
            title: Text(n.title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            subtitle: Text(n.detail,
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: Text(n.time,
                style: const TextStyle(color: Colors.white38, fontSize: 12)),
          );
        },
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconBubble({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white12,
          radius: 16,
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
