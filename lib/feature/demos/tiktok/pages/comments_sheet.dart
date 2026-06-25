import 'package:flutter/material.dart';

class _Comment {
  final String user;
  final String text;
  final String time;
  final int likes;
  final Color avatar;
  const _Comment(this.user, this.text, this.time, this.likes, this.avatar);
}

const _comments = <_Comment>[
  _Comment('@anita', 'This is fire 🔥', '2h', 234, Color(0xFFFFB6C1)),
  _Comment('@dnm', 'Where did you film this?', '1h', 56, Color(0xFF87CEEB)),
  _Comment('@jinal', '💜💜💜', '45m', 12, Color(0xFFFFD700)),
  _Comment('@rahul', 'Tutorial please!', '30m', 89, Color(0xFF98FB98)),
  _Comment('@vishal', 'StarTik to the moon 🚀', '12m', 7, Color(0xFFDDA0DD)),
];

void showCommentsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CommentsSheet(),
  );
}

class _CommentsSheet extends StatelessWidget {
  const _CommentsSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${_comments.length} comments',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _comments.length,
                  itemBuilder: (context, i) => _CommentTile(c: _comments[i]),
                ),
              ),
              const _CommentComposer(),
            ],
          ),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  final _Comment c;
  const _CommentTile({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: c.avatar, radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.user,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                Text(c.text,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(c.time,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Text('Reply',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.favorite_border,
                  color: Colors.white54, size: 20),
              const SizedBox(height: 2),
              Text('${c.likes}',
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        12 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF25F4EE),
            radius: 14,
            child: Text('Y',
                style: TextStyle(color: Colors.black, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add comment...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.emoji_emotions_outlined, color: Colors.white54),
          const SizedBox(width: 8),
          const Icon(Icons.alternate_email, color: Colors.white54),
        ],
      ),
    );
  }
}
