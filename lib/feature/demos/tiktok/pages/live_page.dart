import 'package:flutter/material.dart';

import '../theme.dart';

class _LiveComment {
  final String user;
  final String text;
  final Color avatar;
  const _LiveComment(this.user, this.text, this.avatar);
}

const _liveComments = <_LiveComment>[
  _LiveComment('anita', 'Hi! 👋', Color(0xFFFFB6C1)),
  _LiveComment('dnm', 'Quality is great!', Color(0xFF87CEEB)),
  _LiveComment('rahul', 'Where are you streaming from?', Color(0xFF98FB98)),
  _LiveComment('jinal', '🌟🌟🌟', Color(0xFFFFD700)),
  _LiveComment('vishal', 'Sent you 50 coins! 🪙', Color(0xFFDDA0DD)),
  _LiveComment('priya', 'Love this!! ❤️', Color(0xFFFF6F61)),
];

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // fake video stream
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF4E2C55), Colors.black],
                radius: 0.8,
              ),
            ),
            child: const Center(
              child: Icon(Icons.videocam,
                  color: Colors.white24, size: 96),
            ),
          ),
          // top bar
          Positioned(
            top: 50,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TikTokColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.remove_red_eye,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('1.2K',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          // host info
          Positioned(
            top: 90,
            left: 12,
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFE2C55),
                    radius: 16,
                    child: Text('S',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(width: 8),
                  const Text('@startik_host',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: TikTokColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
          ),
          // live comments overlay
          Positioned(
            left: 12,
            right: 80,
            bottom: 80,
            height: 200,
            child: ListView.builder(
              reverse: false,
              itemCount: _liveComments.length,
              itemBuilder: (context, i) {
                final c = _liveComments[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          backgroundColor: c.avatar, radius: 12),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13),
                              children: [
                                TextSpan(
                                  text: '${c.user}: ',
                                  style: const TextStyle(
                                      color: Colors.white60),
                                ),
                                TextSpan(
                                  text: c.text,
                                  style: const TextStyle(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // bottom action bar
          Positioned(
            left: 12,
            right: 12,
            bottom: 24,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Say something...',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const _LiveActionIcon(icon: Icons.emoji_emotions_outlined),
                const _LiveActionIcon(icon: Icons.card_giftcard),
                const _LiveActionIcon(icon: Icons.share),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveActionIcon extends StatelessWidget {
  final IconData icon;
  const _LiveActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
