import 'package:flutter/material.dart';

import '../theme.dart';
import 'comments_sheet.dart';

class _Video {
  final String username;
  final String caption;
  final String song;
  final Color bgColor;
  final int likes;
  final int comments;
  final int shares;
  final int saves;

  const _Video({
    required this.username,
    required this.caption,
    required this.song,
    required this.bgColor,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.saves,
  });
}

const _hardcodedVideos = <_Video>[
  _Video(
    username: '@flutter_dev',
    caption: 'Building TikTok in Flutter 🚀 #flutter #dev',
    song: 'Original sound — flutter_dev',
    bgColor: Color(0xFF1E1E2E),
    likes: 12400,
    comments: 320,
    shares: 89,
    saves: 412,
  ),
  _Video(
    username: '@dart_lang',
    caption: 'Why Dart 3 patterns slap 🔥',
    song: 'Cool beats — dart_lang',
    bgColor: Color(0xFF2D1B3D),
    likes: 8900,
    comments: 245,
    shares: 56,
    saves: 198,
  ),
  _Video(
    username: '@anita',
    caption: 'My first Flutter app! 💜',
    song: 'happy vibes — anita',
    bgColor: Color(0xFF3D1B2D),
    likes: 5400,
    comments: 180,
    shares: 32,
    saves: 76,
  ),
  _Video(
    username: '@dnm',
    caption: 'Hot reload >>> everything else',
    song: 'Original sound — dnm',
    bgColor: Color(0xFF1B3D2D),
    likes: 21000,
    comments: 502,
    shares: 144,
    saves: 890,
  ),
];

class TikTokFeedPage extends StatefulWidget {
  const TikTokFeedPage({super.key});

  @override
  State<TikTokFeedPage> createState() => _TikTokFeedPageState();
}

class _TikTokFeedPageState extends State<TikTokFeedPage> {
  bool _forYou = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _hardcodedVideos.length,
            itemBuilder: (context, i) =>
                _VideoTile(video: _hardcodedVideos[i]),
          ),
          // top tabs (Following / For You)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _forYou = false),
                  child: Text('Following',
                      style: TextStyle(
                        color: _forYou ? Colors.white54 : Colors.white,
                        fontSize: 16,
                        fontWeight:
                            _forYou ? FontWeight.normal : FontWeight.bold,
                      )),
                ),
                const SizedBox(width: 16),
                const Text('|',
                    style: TextStyle(color: Colors.white24, fontSize: 16)),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _forYou = true),
                  child: Text('For You',
                      style: TextStyle(
                        color: _forYou ? Colors.white : Colors.white54,
                        fontSize: 16,
                        fontWeight:
                            _forYou ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final _Video video;
  const _VideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: video.bgColor),
        const Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white24,
            size: 96,
          ),
        ),
        // caption + user
        Positioned(
          left: 16,
          right: 80,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(video.username,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Follow',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(video.caption,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.music_note,
                      color: TikTokColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(video.song,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        // side actions
        Positioned(
          right: 12,
          bottom: 24,
          child: Column(
            children: [
              _SideAction(
                icon: Icons.favorite,
                count: video.likes,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SideAction(
                icon: Icons.comment,
                count: video.comments,
                onTap: () => showCommentsSheet(context),
              ),
              const SizedBox(height: 16),
              _SideAction(
                icon: Icons.bookmark,
                count: video.saves,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SideAction(
                icon: Icons.share,
                count: video.shares,
                onTap: () => _showShareSheet(context),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showReportSheet(context),
                child: const Icon(Icons.more_horiz,
                    color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            children: const [
              _ShareIcon(icon: Icons.send, label: 'Direct'),
              _ShareIcon(icon: Icons.message, label: 'Message'),
              _ShareIcon(icon: Icons.copy, label: 'Copy link'),
              _ShareIcon(icon: Icons.download, label: 'Save'),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.white),
              title: const Text('Report',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.white),
              title: const Text('Block user',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.white),
              title: const Text('Not interested',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  const _SideAction({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 4),
          Text(
            _format(count),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _ShareIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ShareIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white12,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
