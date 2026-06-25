import 'package:flutter/material.dart';

import '../theme.dart';
import 'live_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('@you',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF1A1A1A),
                builder: (_) => const _SettingsSheet(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: TikTokColors.primary,
              child: Text('Y',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('@you',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(value: '128', label: 'Following'),
                _StatDivider(),
                _Stat(value: '2.4K', label: 'Followers'),
                _StatDivider(),
                _Stat(value: '18.2K', label: 'Likes'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Edit profile',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Share profile',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.person_add,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Flutter dev · building StarTik 🚀\nMVP launching soon',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: TikTokColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.live_tv),
              label: const Text('Go Live'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LivePage()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on)),
                    Tab(icon: Icon(Icons.lock_outline)),
                    Tab(icon: Icon(Icons.favorite_border)),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      _PostsGrid(),
                      const Center(
                        child: Text('Private videos',
                            style: TextStyle(color: Colors.white54)),
                      ),
                      const Center(
                        child: Text('Liked videos',
                            style: TextStyle(color: Colors.white54)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 24, color: Colors.white12);
}

class _PostsGrid extends StatelessWidget {
  static const _colors = <Color>[
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: 12,
      itemBuilder: (context, i) {
        final color = _colors[i % _colors.length];
        return Container(
          color: color,
          child: Stack(
            children: [
              const Center(
                child: Icon(Icons.play_arrow,
                    color: Colors.white24, size: 32),
              ),
              Positioned(
                left: 4,
                bottom: 4,
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow,
                        color: Colors.white, size: 12),
                    const SizedBox(width: 2),
                    Text('${(i + 1) * 8}K',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _SettingsTile(icon: Icons.settings, label: 'Settings and privacy'),
          _SettingsTile(icon: Icons.policy, label: 'Privacy Policy'),
          _SettingsTile(icon: Icons.description, label: 'Terms of Service'),
          _SettingsTile(icon: Icons.help_outline, label: 'Help & support'),
          _SettingsTile(
              icon: Icons.delete_outline,
              label: 'Delete account',
              danger: true),
          _SettingsTile(
              icon: Icons.logout, label: 'Log out', danger: true),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red[300] : Colors.white;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
