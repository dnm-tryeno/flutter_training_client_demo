import 'package:flutter/material.dart';

import '../theme.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          backgroundColor: TikTokColors.primary,
          foregroundColor: Colors.white,
          title: const Text('StarTik Admin'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.flag), text: 'Reports'),
              Tab(icon: Icon(Icons.people), text: 'Users'),
              Tab(icon: Icon(Icons.videocam), text: 'Content'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ReportsTab(),
            _UsersTab(),
            _ContentTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------- Tab 1: Reports & Moderation ----------------

class _Report {
  final String reporter;
  final String target;
  final String reason;
  final String time;
  final IconData icon;
  const _Report(this.reporter, this.target, this.reason, this.time, this.icon);
}

const _reports = <_Report>[
  _Report('@anita', 'video by @flutter_dev', 'Spam', '2h ago', Icons.videocam),
  _Report('@dnm', 'comment by @vishal', 'Harassment', '3h ago', Icons.comment),
  _Report('@rahul', 'user @suspicious_acc', 'Fake account', '5h ago', Icons.person),
  _Report('@jinal', 'video by @random_user', 'Inappropriate content', '8h ago', Icons.videocam),
  _Report('@priya', 'live stream by @host_xyz', 'Adult content', '1d ago', Icons.live_tv),
];

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(items: const [
          _SummaryCard(label: 'Pending', value: '12', color: Color(0xFFFFB300)),
          _SummaryCard(label: 'Resolved today', value: '34', color: Color(0xFF4CAF50)),
          _SummaryCard(label: 'Removed', value: '8', color: Color(0xFFFE2C55)),
        ]),
        Expanded(
          child: ListView.separated(
            itemCount: _reports.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final r = _reports[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: Icon(r.icon, color: Colors.orange.shade800, size: 20),
                ),
                title: Text('${r.reason} — ${r.target}',
                    style: const TextStyle(fontSize: 14)),
                subtitle: Text('Reported by ${r.reporter} · ${r.time}',
                    style: const TextStyle(fontSize: 12)),
                trailing: PopupMenuButton<String>(
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'review', child: Text('Review')),
                    PopupMenuItem(value: 'remove', child: Text('Remove content')),
                    PopupMenuItem(value: 'ban', child: Text('Ban user')),
                    PopupMenuItem(value: 'dismiss', child: Text('Dismiss')),
                  ],
                  onSelected: (_) {},
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------- Tab 2: Users ----------------

class _AdminUser {
  final String handle;
  final String email;
  final int followers;
  final bool banned;
  final Color avatar;
  const _AdminUser(this.handle, this.email, this.followers, this.banned, this.avatar);
}

const _users = <_AdminUser>[
  _AdminUser('@flutter_dev', 'flutter@example.com', 12400, false, Color(0xFF87CEEB)),
  _AdminUser('@anita', 'anita@example.com', 5400, false, Color(0xFFFFB6C1)),
  _AdminUser('@dnm', 'dnm@example.com', 21000, false, Color(0xFF98FB98)),
  _AdminUser('@suspicious_acc', 'spam@example.com', 12, true, Color(0xFFE57373)),
  _AdminUser('@host_xyz', 'host@example.com', 845, false, Color(0xFFFFD700)),
  _AdminUser('@priya', 'priya@example.com', 2200, false, Color(0xFFDDA0DD)),
];

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.black54, size: 20),
                SizedBox(width: 8),
                Text('Search by handle or email',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _users.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final u = _users[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: u.avatar,
                  child: Text(u.handle[1].toUpperCase(),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Row(
                  children: [
                    Text(u.handle,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (u.banned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('BANNED',
                            style: TextStyle(
                              color: Colors.red.shade800,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                  ],
                ),
                subtitle: Text('${u.email} · ${u.followers} followers',
                    style: const TextStyle(fontSize: 12)),
                trailing: PopupMenuButton<String>(
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'view', child: Text('View details')),
                    PopupMenuItem(
                      value: 'ban',
                      child: Text(u.banned ? 'Unban' : 'Ban / Suspend'),
                    ),
                  ],
                  onSelected: (_) {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------- Tab 3: Content & Live Monitor ----------------

class _LiveStream {
  final String host;
  final int viewers;
  final Color color;
  const _LiveStream(this.host, this.viewers, this.color);
}

const _liveStreams = <_LiveStream>[
  _LiveStream('@startik_host', 1234, Color(0xFFFE2C55)),
  _LiveStream('@dnm', 562, Color(0xFF98FB98)),
  _LiveStream('@anita', 89, Color(0xFFFFB6C1)),
];

const _recentUploads = <Color>[
  Color(0xFF1E1E2E),
  Color(0xFF2D1B3D),
  Color(0xFF3D1B2D),
  Color(0xFF1B3D2D),
  Color(0xFF3D2D1B),
  Color(0xFF1B2D3D),
  Color(0xFF2D3D1B),
  Color(0xFF3D1B1B),
  Color(0xFF1B1B3D),
];

class _ContentTab extends StatelessWidget {
  const _ContentTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Active live streams',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ..._liveStreams.map((s) => ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(backgroundColor: s.color),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(s.host,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${s.viewers} viewers'),
              trailing: TextButton.icon(
                icon: const Icon(Icons.stop, size: 16),
                label: const Text('End stream'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {},
              ),
            )),
        const Divider(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Recent uploads',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.7,
            ),
            itemCount: 9,
            itemBuilder: (context, i) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: _recentUploads[i % _recentUploads.length]),
                  const Center(
                    child: Icon(Icons.play_arrow,
                        color: Colors.white38, size: 24),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 12),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ---------------- Shared ----------------

class _SummaryRow extends StatelessWidget {
  final List<_SummaryCard> items;
  const _SummaryRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: items
            .expand((c) => [Expanded(child: c), const SizedBox(width: 8)])
            .take(items.length * 2 - 1)
            .toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
