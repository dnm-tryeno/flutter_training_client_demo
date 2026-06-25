import 'package:flutter/material.dart';

import 'discover_page.dart';
import 'inbox_page.dart';
import 'profile_page.dart';
import 'tiktok_feed_page.dart';
import 'upload_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  final _pages = const <Widget>[
    TikTokFeedPage(),
    DiscoverPage(),
    SizedBox.shrink(), // upload opens as modal
    InboxPage(),
    ProfilePage(),
  ];

  void _onTap(int i) {
    if (i == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const UploadPage(),
        ),
      );
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                selected: _index == 0,
                onTap: () => _onTap(0),
              ),
              _NavItem(
                icon: Icons.search,
                label: 'Discover',
                selected: _index == 1,
                onTap: () => _onTap(1),
              ),
              _AddButton(onTap: () => _onTap(2)),
              _NavItem(
                icon: Icons.inbox,
                label: 'Inbox',
                selected: _index == 3,
                onTap: () => _onTap(3),
              ),
              _NavItem(
                icon: Icons.person,
                label: 'Me',
                selected: _index == 4,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.white60;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFF25F4EE), Color(0xFFFE2C55)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 22),
      ),
    );
  }
}
