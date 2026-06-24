import 'package:flutter/material.dart';

import '../theme.dart';

class _Video {
  final String username;
  final String caption;
  final String song;
  final Color bgColor;
  final int likes;
  final int comments;
  final int shares;

  const _Video({
    required this.username,
    required this.caption,
    required this.song,
    required this.bgColor,
    required this.likes,
    required this.comments,
    required this.shares,
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
  ),
  _Video(
    username: '@dart_lang',
    caption: 'Why Dart 3 patterns slap 🔥',
    song: 'Cool beats — dart_lang',
    bgColor: Color(0xFF2D1B3D),
    likes: 8900,
    comments: 245,
    shares: 56,
  ),
  _Video(
    username: '@anita',
    caption: 'My first Flutter app! 💜',
    song: 'happy vibes — anita',
    bgColor: Color(0xFF3D1B2D),
    likes: 5400,
    comments: 180,
    shares: 32,
  ),
  _Video(
    username: '@dnm',
    caption: 'Hot reload >>> everything else',
    song: 'Original sound — dnm',
    bgColor: Color(0xFF1B3D2D),
    likes: 21000,
    comments: 502,
    shares: 144,
  ),
];

class TikTokFeedPage extends StatelessWidget {
  const TikTokFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _hardcodedVideos.length,
        itemBuilder: (context, i) => _VideoTile(video: _hardcodedVideos[i]),
      ),
      bottomNavigationBar: const _TikTokBottomBar(),
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
        // fake video background
        Container(color: video.bgColor),
        Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white24,
            size: 96,
          ),
        ),
        // top bar
        const Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Following',
                  style: TextStyle(color: Colors.white54, fontSize: 16)),
              SizedBox(width: 16),
              Text('|',
                  style: TextStyle(color: Colors.white24, fontSize: 16)),
              SizedBox(width: 16),
              Text('For You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ],
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
              Text(video.username,
                  style: Theme.of(context).textTheme.titleLarge),
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
              _SideAction(icon: Icons.favorite, count: video.likes),
              const SizedBox(height: 20),
              _SideAction(icon: Icons.comment, count: video.comments),
              const SizedBox(height: 20),
              _SideAction(icon: Icons.share, count: video.shares),
            ],
          ),
        ),
      ],
    );
  }
}

class _SideAction extends StatelessWidget {
  final IconData icon;
  final int count;
  const _SideAction({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        const SizedBox(height: 4),
        Text(
          _format(count),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _TikTokBottomBar extends StatelessWidget {
  const _TikTokBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomItem(icon: Icons.home, label: 'Home'),
          _BottomItem(icon: Icons.search, label: 'Discover'),
          _BottomItem(icon: Icons.add_box, label: ''),
          _BottomItem(icon: Icons.inbox, label: 'Inbox'),
          _BottomItem(icon: Icons.person, label: 'Me'),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
