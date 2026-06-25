import 'package:flutter/material.dart';

import '../theme.dart';

class _Post {
  final String username;
  final Color avatar;
  final Color image;
  final String caption;
  final int likes;

  const _Post({
    required this.username,
    required this.avatar,
    required this.image,
    required this.caption,
    required this.likes,
  });
}

class _Story {
  final String name;
  final Color color;
  const _Story(this.name, this.color);
}

const _stories = <_Story>[
  _Story('Your story', Color(0xFFCCCCCC)),
  _Story('jinal', Color(0xFFFFB6C1)),
  _Story('rahul', Color(0xFF87CEEB)),
  _Story('anita', Color(0xFFFFD700)),
  _Story('dnm', Color(0xFF98FB98)),
  _Story('vishal', Color(0xFFDDA0DD)),
];

const _posts = <_Post>[
  _Post(
    username: 'jinal',
    avatar: Color(0xFFFFB6C1),
    image: Color(0xFFFFE4E1),
    caption: 'Sunset vibes 🌅',
    likes: 234,
  ),
  _Post(
    username: 'rahul',
    avatar: Color(0xFF87CEEB),
    image: Color(0xFFB0E0E6),
    caption: 'Coffee time ☕',
    likes: 178,
  ),
  _Post(
    username: 'anita',
    avatar: Color(0xFFFFD700),
    image: Color(0xFFFFFACD),
    caption: 'New Flutter project 💜',
    likes: 412,
  ),
];

class InstagramFeedPage extends StatelessWidget {
  const InstagramFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
        actions: const [
          Icon(Icons.favorite_border, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.send, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        children: [
          // stories
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _stories.length,
              itemBuilder: (context, i) {
                final story = _stories[i];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [InstaColors.primary, InstaColors.accent],
                          ),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(backgroundColor: story.color),
                      ),
                      const SizedBox(height: 4),
                      Text(story.name,
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 0),
          // posts
          ..._posts.map((p) => _PostTile(post: p)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  final _Post post;
  const _PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(backgroundColor: post.avatar),
          title: Text(post.username,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.more_horiz),
        ),
        AspectRatio(aspectRatio: 1, child: Container(color: post.image)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline),
              SizedBox(width: 16),
              Icon(Icons.send),
              Spacer(),
              Icon(Icons.bookmark_border),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('${post.likes} likes',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: '${post.username} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
