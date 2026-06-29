import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/app_drawer.dart';
import 'batches_page.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'notifications_page.dart';
import 'performance_page.dart';
import 'profile_page.dart';

/// Bottom-navigation host for the logged-in experience.
class LmsMainScaffold extends StatefulWidget {
  const LmsMainScaffold({super.key});

  @override
  State<LmsMainScaffold> createState() => _LmsMainScaffoldState();
}

class _LmsMainScaffoldState extends State<LmsMainScaffold> {
  int _index = 0;

  static const _titles = ['Home', 'Batches', 'Performance', 'Chat', 'Profile'];

  final _pages = const <Widget>[
    HomePage(),
    BatchesPage(),
    PerformancePage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LmsDrawer(),
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: LmsColors.primary,
              child: const Text('HP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: LmsColors.surface,
        indicatorColor: LmsColors.primary.withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: LmsColors.primary),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view, color: LmsColors.primary),
              label: 'Batches'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights, color: LmsColors.primary),
              label: 'Performance'),
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon:
                  Icon(Icons.chat_bubble, color: LmsColors.primary),
              label: 'Chat'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: LmsColors.primary),
              label: 'Profile'),
        ],
      ),
    );
  }
}
