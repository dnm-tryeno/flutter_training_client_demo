import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const _purple = Color(0xFF7B4DFF);
const _pink = Color(0xFFFF4D9D);
const _ink = Color(0xFF171326);
const _bg = Color(0xFFF7F5FC);

class VoiceChatApp extends StatelessWidget {
  const VoiceChatApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'VibeRoom',
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(seedColor: _purple),
      scaffoldBackgroundColor: _bg,
    ),
    home: const _SplashPage(),
  );
}

class _SplashPage extends StatefulWidget {
  const _SplashPage();
  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted)
        Navigator.pushReplacement(context, _fade(const _LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF351C84), _purple, _pink],
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween(begin: .75, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Logo(size: 108),
                SizedBox(height: 22),
                Text(
                  'VibeRoom',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.8,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Speak. Connect. Celebrate.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _LoginPage extends StatelessWidget {
  const _LoginPage();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/voice_chat/party_friends.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x443B247A), Color(0xF5151025)],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 38, 24, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Logo(size: 60),
                const Spacer(),
                const Text(
                  'Your voice.\nYour people.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Join live rooms, meet new friends and own the spotlight.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 30),
                _LoginButton(
                  icon: Icons.phone_iphone_rounded,
                  text: 'Continue with phone',
                  onTap: () => Navigator.pushReplacement(
                    context,
                    _fade(const _MainShell()),
                  ),
                ),
                const SizedBox(height: 12),
                _LoginButton(
                  icon: Icons.g_mobiledata_rounded,
                  text: 'Continue with Google',
                  light: true,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    _fade(const _MainShell()),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.light = false,
  });
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool light;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: light ? Colors.white : _purple,
        foregroundColor: light ? _ink : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
  );
}

class _MainShell extends StatefulWidget {
  const _MainShell();
  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int index = 0;
  late final pages = [
    const _HomePage(),
    const _MomentsPage(),
    const _PartyPage(),
    const _ChatsPage(),
    const _ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      indicatorColor: _purple.withValues(alpha: .14),
      onDestinationSelected: (i) => setState(() => index = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_mosaic_outlined),
          selectedIcon: Icon(Icons.auto_awesome_mosaic),
          label: 'Moments',
        ),
        NavigationDestination(icon: _PartyNavIcon(), label: 'Party'),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    ),
  );
}

class _HomePage extends StatefulWidget {
  const _HomePage();
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int category = 0;
  final cats = const ['Popular', 'Party', 'PK', 'New'];
  @override
  Widget build(BuildContext context) => SafeArea(
    child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                const _Logo(size: 44, colored: true),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VibeRoom',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Find your vibe ✨',
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _CircleButton(
                  icon: Icons.search_rounded,
                  onTap: () => _toast(context, 'Search is ready for the demo'),
                ),
                const SizedBox(width: 8),
                Badge(
                  label: const Text('3'),
                  child: _CircleButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () => _toast(context, 'You have 3 new room invites'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 58,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(cats[i]),
                selected: category == i,
                onSelected: (_) => setState(() => category = i),
                selectedColor: _ink,
                labelStyle: TextStyle(
                  color: category == i ? Colors.white : _ink,
                  fontWeight: FontWeight.w700,
                ),
                side: BorderSide.none,
                backgroundColor: Colors.white,
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: cats.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: _HeroRoom(
              onTap: () =>
                  Navigator.push(context, _fade(const _VoiceRoomPage())),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _SectionTitle(title: 'Live now', action: 'See all'),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: .78,
            ),
            delegate: SliverChildListDelegate([
              _RoomCard(
                title: 'Late Night Talks',
                host: 'Sara',
                people: '1.2K',
                image: 'profile_sara.jpg',
                color: Color(0xFF7C3AED),
              ),
              _RoomCard(
                title: 'Bollywood Beats',
                host: 'Aarav',
                people: '856',
                image: 'host_aarav.jpg',
                color: Color(0xFFFF4D75),
              ),
              _RoomCard(
                title: 'Meet New Friends',
                host: 'Nina',
                people: '643',
                image: 'profile_nina.jpg',
                color: Color(0xFF00A5A5),
              ),
              _RoomCard(
                title: 'Global Party',
                host: 'Ryan',
                people: '2.4K',
                image: 'profile_ryan.jpg',
                color: Color(0xFFFF8A00),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}

class _HeroRoom extends StatelessWidget {
  const _HeroRoom({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage('assets/images/voice_chat/party_stage.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: .22),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.transparent, Color(0xDD24103F)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.graphic_eq, color: Colors.white, size: 15),
                      SizedBox(width: 5),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white70,
                  size: 17,
                ),
                const SizedBox(width: 5),
                const Text(
                  '3.8K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'Friday Night Party 🎉',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Music • Games • New friends',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const _StackedAvatars(),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Maya & 12 hosts',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _purple,
                  ),
                  onPressed: onTap,
                  child: const Text(
                    'Join room',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.title,
    required this.host,
    required this.people,
    required this.image,
    required this.color,
  });
  final String title, host, people, image;
  final Color color;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, _fade(const _VoiceRoomPage())),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.asset(
                    'assets/images/voice_chat/$image',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 9,
                  left: 10,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.headphones_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        people,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hosted by $host',
                  style: const TextStyle(color: Colors.black45, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _VoiceRoomPage extends StatefulWidget {
  const _VoiceRoomPage();
  @override
  State<_VoiceRoomPage> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends State<_VoiceRoomPage> {
  bool onMic = false, muted = false;
  int audience = 3842, coins = 12500;
  String? gift;
  final chat = <String>[
    '✨ Nina joined the room',
    'Ryan: This vibe is amazing!',
    'Sara: Play another song please 🎵',
    'Maya: Welcome everyone 💜',
  ];
  final controller = TextEditingController();
  void send() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      chat.add('You: ${controller.text.trim()}');
      controller.clear();
    });
  }

  void showGift(String emoji, int cost) {
    if (coins < cost) return;
    setState(() {
      coins -= cost;
      gift = emoji;
      chat.add('You sent $emoji to Maya!');
    });
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 2100), () {
      if (mounted) setState(() => gift = null);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF201038),
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/voice_chat/party_stage.jpg',
            fit: BoxFit.cover,
            color: const Color(0xAA1B0E34),
            colorBlendMode: BlendMode.srcATop,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x551E093A), Color(0xFA140C22)],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 14, 4),
                child: Row(
                  children: [
                    _DarkCircle(
                      icon: Icons.keyboard_arrow_down_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 9),
                    const _Avatar('host_maya.jpg', size: 43, border: _pink),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Friday Night Party 🎉',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Maya  •  ID 784201',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => audience++),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_purple, _pink],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '+ Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white54,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$audience listening',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    _TinyPill(
                      icon: Icons.share_rounded,
                      text: 'Invite',
                      onTap: () => _toast(context, 'Room invite copied!'),
                    ),
                    const SizedBox(width: 7),
                    _TinyPill(
                      icon: Icons.workspace_premium_rounded,
                      text: 'PK',
                      color: _pink,
                      onTap: () =>
                          Navigator.push(context, _fade(const _PkPage())),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: .77,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: 12,
                  itemBuilder: (_, i) {
                    final names = [
                      'Maya',
                      'Sara',
                      'Ryan',
                      'Nina',
                      'Zoe',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                    ];
                    final imgs = [
                      'host_maya.jpg',
                      'profile_sara.jpg',
                      'profile_ryan.jpg',
                      'profile_nina.jpg',
                      'profile_zoe.jpg',
                    ];
                    final mine = i == 5 && onMic;
                    return GestureDetector(
                      onTap: i == 5
                          ? () => setState(() => onMic = !onMic)
                          : null,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 62,
                                height: 62,
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: (i < 5 || mine)
                                        ? [_purple, _pink, Colors.orange]
                                        : [Colors.white12, Colors.white10],
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF26153B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: i < 5
                                      ? _Avatar(imgs[i], size: 54)
                                      : mine
                                      ? const Center(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: Colors.white38,
                                            size: 25,
                                          ),
                                        ),
                                ),
                              ),
                              if (i < 5 || mine)
                                Positioned(
                                  right: 0,
                                  bottom: 1,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: (mine && muted)
                                          ? Colors.red
                                          : const Color(0xFF34D399),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF201038),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      (mine && muted)
                                          ? Icons.mic_off
                                          : Icons.graphic_eq,
                                      color: Colors.white,
                                      size: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            i < 5
                                ? names[i]
                                : mine
                                ? 'You'
                                : 'Seat ${i + 1}',
                            maxLines: 1,
                            style: TextStyle(
                              color: (i < 5 || mine)
                                  ? Colors.white
                                  : Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (i == 0)
                            const Text(
                              'HOST 👑',
                              style: TextStyle(
                                color: Color(0xFFFFCA4A),
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chat.length,
                  itemBuilder: (_, i) {
                    final text = chat[chat.length - 1 - i];
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: text.startsWith('You')
                                ? const Color(0xFFFFD266)
                                : Colors.white.withValues(alpha: .86),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 13),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onSubmitted: (_) => send(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white10,
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: send,
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white70,
                              size: 19,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ActionBubble(
                      icon: onMic
                          ? (muted ? Icons.mic_off : Icons.mic)
                          : Icons.mic_none_rounded,
                      label: onMic ? (muted ? 'Unmute' : 'Mute') : 'Mic',
                      color: onMic ? _purple : Colors.white12,
                      onTap: () => setState(() {
                        if (!onMic) {
                          onMic = true;
                        } else {
                          muted = !muted;
                        }
                      }),
                    ),
                    _ActionBubble(
                      icon: Icons.card_giftcard_rounded,
                      label: 'Gift',
                      color: _pink,
                      onTap: () => _showGifts(context),
                    ),
                    _ActionBubble(
                      icon: Icons.more_horiz_rounded,
                      label: 'More',
                      color: Colors.white12,
                      onTap: () => _toast(context, 'More room controls'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (gift != null)
          Positioned.fill(
            child: IgnorePointer(child: _GiftAnimation(emoji: gift!)),
          ),
      ],
    ),
  );

  void _showGifts(BuildContext context) => showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF241435),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Send a gift',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.monetization_on_rounded,
                  color: Color(0xFFFFC640),
                  size: 19,
                ),
                const SizedBox(width: 5),
                Text(
                  '$coins',
                  style: const TextStyle(
                    color: Color(0xFFFFD36A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _toast(context, 'Demo coins added'),
                  child: const Text('Recharge'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _GiftItem(
                  emoji: '🌹',
                  name: 'Rose',
                  coins: 10,
                  onTap: () => showGift('🌹', 10),
                ),
                _GiftItem(
                  emoji: '❤️',
                  name: 'Heart',
                  coins: 50,
                  onTap: () => showGift('❤️', 50),
                ),
                _GiftItem(
                  emoji: '🚗',
                  name: 'Super Car',
                  coins: 500,
                  onTap: () => showGift('🚗', 500),
                ),
                _GiftItem(
                  emoji: '👑',
                  name: 'Crown',
                  coins: 999,
                  onTap: () => showGift('👑', 999),
                ),
                _GiftItem(
                  emoji: '🐉',
                  name: 'Dragon',
                  coins: 1999,
                  onTap: () => showGift('🐉', 1999),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _GiftAnimation extends StatefulWidget {
  const _GiftAnimation({required this.emoji});
  final String emoji;
  @override
  State<_GiftAnimation> createState() => _GiftAnimationState();
}

class _GiftAnimationState extends State<_GiftAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  )..forward();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (_, __) {
      final pulse = 1 + math.sin(c.value * math.pi * 4) * .08;
      return Container(
        color: Colors.black.withValues(
          alpha: .22 * math.sin(c.value * math.pi),
        ),
        child: Center(
          child: Transform.scale(
            scale:
                Curves.elasticOut.transform(c.value.clamp(0, .7) / .7) * pulse,
            child: Opacity(
              opacity: (1 - ((c.value - .72).clamp(0, .28) / .28)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.emoji, style: const TextStyle(fontSize: 138)),
                  const Text(
                    'YOU SENT A LEGENDARY GIFT!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      shadows: [Shadow(color: _pink, blurRadius: 18)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _PkPage extends StatefulWidget {
  const _PkPage();
  @override
  State<_PkPage> createState() => _PkPageState();
}

class _PkPageState extends State<_PkPage> {
  int a = 62, b = 38, seconds = 58;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && seconds > 0) setState(() => seconds--);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF140D20),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _DarkCircle(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text(
                  'PK BATTLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
                const Spacer(),
                _DarkCircle(icon: Icons.more_horiz, onTap: () {}),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _PkHost(
                        name: 'Maya',
                        image: 'host_maya.jpg',
                        score: a,
                        color: _purple,
                      ),
                    ),
                    Expanded(
                      child: _PkHost(
                        name: 'Aarav',
                        image: 'host_aarav.jpg',
                        score: b,
                        color: _pink,
                      ),
                    ),
                  ],
                ),
                const Center(child: _VsBadge()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF21162C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Text(
                  '00:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Send gifts to support your host',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: a,
                        child: Container(height: 16, color: _purple),
                      ),
                      Expanded(
                        flex: b,
                        child: Container(height: 16, color: _pink),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        '⚡ $a K',
                        style: const TextStyle(
                          color: Color(0xFFB69BFF),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$b K ⚡',
                        style: const TextStyle(
                          color: Color(0xFFFF88BD),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final g in [
                      ('🌹', 1),
                      ('❤️', 3),
                      ('👑', 7),
                      ('🐉', 12),
                    ])
                      GestureDetector(
                        onTap: () => setState(() {
                          a += g.$2;
                          final total = a + b;
                          a = (a * 100 / total).round();
                          b = 100 - a;
                        }),
                        child: Container(
                          width: 65,
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Column(
                            children: [
                              Text(g.$1, style: const TextStyle(fontSize: 27)),
                              Text(
                                '+${g.$2}K',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _PkHost extends StatelessWidget {
  const _PkHost({
    required this.name,
    required this.image,
    required this.score,
    required this.color,
  });
  final String name, image;
  final int score;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/voice_chat/$image'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, color.withValues(alpha: .82)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$score K points',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

class _MomentsPage extends StatefulWidget {
  const _MomentsPage();
  @override
  State<_MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<_MomentsPage> {
  final liked = <int>{};
  @override
  Widget build(BuildContext context) => SafeArea(
    child: CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Text(
                  'Moments',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: _ink,
                  child: Icon(Icons.add_a_photo_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((_, i) {
            final data = i == 0
                ? (
                    'Nina Kapoor',
                    'profile_nina.jpg',
                    'moment_style.jpg',
                    'City lights and main character energy ✨',
                  )
                : (
                    'Ryan Cole',
                    'profile_ryan.jpg',
                    'party_friends.jpg',
                    'Found my people on VibeRoom 💜',
                  );
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 5, 16, 18),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Avatar(data.$2, size: 43),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              '2m ago • Level 24',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            _toast(context, 'Following ${data.$1}'),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 1.18,
                      child: Image.asset(
                        'assets/images/voice_chat/${data.$3}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    data.$4,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(
                          () => liked.contains(i)
                              ? liked.remove(i)
                              : liked.add(i),
                        ),
                        icon: Icon(
                          liked.contains(i)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: liked.contains(i) ? _pink : _ink,
                        ),
                      ),
                      Text('${liked.contains(i) ? 129 : 128}'),
                      IconButton(
                        onPressed: () => _toast(context, 'Comment box opened'),
                        icon: const Icon(Icons.chat_bubble_outline),
                      ),
                      const Text('24'),
                      const Spacer(),
                      const Icon(Icons.bookmark_border_rounded),
                    ],
                  ),
                ],
              ),
            );
          }, childCount: 2),
        ),
      ],
    ),
  );
}

class _PartyPage extends StatelessWidget {
  const _PartyPage();
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Party',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pick a vibe and start a room',
            style: TextStyle(color: Colors.black45),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: [
                _PartyTile('🎤', 'Karaoke', 'Sing together', const [
                  Color(0xFF4F46E5),
                  Color(0xFF8B5CF6),
                ]),
                _PartyTile('🎮', 'Game Night', 'Play & win', const [
                  Color(0xFFFF5B76),
                  Color(0xFFFF955B),
                ]),
                _PartyTile('⚔️', 'PK Arena', 'Battle live', const [
                  Color(0xFF111827),
                  Color(0xFF7C3AED),
                ]),
                _PartyTile('💬', 'Chill Talk', 'Meet friends', const [
                  Color(0xFF0891B2),
                  Color(0xFF22C55E),
                ]),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () =>
                  Navigator.push(context, _fade(const _VoiceRoomPage())),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                'Create your room',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ChatsPage extends StatelessWidget {
  const _ChatsPage();
  @override
  Widget build(BuildContext context) {
    final users = [
      ('VibeRoom Official', '🎉 Welcome to the community!', 'host_maya.jpg'),
      ('Nina Kapoor', 'That room was so much fun ❤️', 'profile_nina.jpg'),
      ('Ryan Cole', 'See you in the PK battle', 'profile_ryan.jpg'),
      ('Sara Khan', 'Sent you a voice message', 'profile_sara.jpg'),
    ];
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(
              children: [
                Text(
                  'Messages',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                Spacer(),
                Icon(Icons.search_rounded),
                SizedBox(width: 18),
                Icon(Icons.edit_square),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(indent: 75, height: 1),
              itemBuilder: (_, i) => ListTile(
                onTap: () => Navigator.push(
                  context,
                  _fade(_PrivateChat(name: users[i].$1, image: users[i].$3)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 7,
                ),
                leading: Stack(
                  children: [
                    _Avatar(users[i].$3, size: 55),
                    if (i > 0)
                      const Positioned(
                        right: 1,
                        bottom: 1,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Color(0xFF22C55E),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  users[i].$1,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(users[i].$2, maxLines: 1),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${9 + i}:2$i',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black38,
                      ),
                    ),
                    if (i < 2)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: 19,
                        height: 19,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: _purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateChat extends StatefulWidget {
  const _PrivateChat({required this.name, required this.image});
  final String name, image;
  @override
  State<_PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<_PrivateChat> {
  final messages = <String>[
    'Hey! That party room was amazing 🎉',
    'Totally! Are you joining again tonight?',
  ];
  final c = TextEditingController();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          _Avatar(widget.image, size: 39),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'online',
                style: TextStyle(fontSize: 10, color: Color(0xFF22C55E)),
              ),
            ],
          ),
        ],
      ),
      actions: const [Icon(Icons.call_outlined), SizedBox(width: 16)],
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, i) => Align(
              alignment: i.isEven
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : _purple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  messages[i],
                  style: TextStyle(color: i.isEven ? _ink : Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: c,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (c.text.trim().isNotEmpty)
                    setState(() {
                      messages.add(c.text.trim());
                      c.clear();
                    });
                },
                icon: const Icon(Icons.send_rounded, color: _purple),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Row(
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF33215D), Color(0xFF7542C9)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  _Avatar(
                    'profile_zoe.jpg',
                    size: 78,
                    border: Color(0xFFFFD34E),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Zoe Walker',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'VIP 5',
                              style: TextStyle(
                                color: Color(0xFFFFD34E),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '@zoevibes  •  ID 842019',
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Living loud, loving life ✨',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat('128K', 'Followers'),
                  _Stat('842', 'Following'),
                  _Stat('2.4M', 'Diamonds'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _vipSheet(context),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC846), Color(0xFFFF7A45)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Text('👑', style: TextStyle(fontSize: 36)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vibe VIP',
                        style: TextStyle(
                          color: Color(0xFF4B2500),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Unlock exclusive frames, gifts & entry effects',
                        style: TextStyle(
                          color: Color(0xAA4B2500),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF4B2500),
                  size: 17,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _SectionTitle(title: 'My highlights', action: ''),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ProfileTile(
                icon: Icons.card_giftcard,
                value: '1,284',
                label: 'Gifts received',
                color: _pink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProfileTile(
                icon: Icons.mic,
                value: '42h',
                label: 'Voice time',
                color: _purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (final item in [
          (Icons.workspace_premium_outlined, 'Level center'),
          (Icons.account_balance_wallet_outlined, 'Wallet & coins'),
          (Icons.people_outline, 'Friends'),
          (Icons.shield_outlined, 'Safety center'),
        ])
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: _purple.withValues(alpha: .1),
              child: Icon(item.$1, color: _purple),
            ),
            title: Text(
              item.$2,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
      ],
    ),
  );
}

void _vipSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: const Color(0xFF1A1225),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
  ),
  builder: (_) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('👑', style: TextStyle(fontSize: 52)),
          const Text(
            'Rule the room with VIP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Stand out every time you enter',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 22),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _VipBenefit('💎', 'VIP badge'),
              _VipBenefit('🖼️', 'Profile frame'),
              _VipBenefit('✨', 'Entry effect'),
              _VipBenefit('🎁', 'Rare gifts'),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _Plan('VIP', '₹299 / mo', false)),
              const SizedBox(width: 10),
              Expanded(child: _Plan('SVIP', '₹799 / mo', true)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFC447),
                foregroundColor: _ink,
              ),
              onPressed: () {
                Navigator.pop(context);
                _toast(context, 'SVIP activated for demo ✨');
              },
              child: const Text(
                'Start demo membership',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

class _Logo extends StatelessWidget {
  const _Logo({required this.size, this.colored = false});
  final double size;
  final bool colored;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: colored ? _purple : Colors.white.withValues(alpha: .16),
      gradient: colored ? const LinearGradient(colors: [_purple, _pink]) : null,
      borderRadius: BorderRadius.circular(size * .3),
      border: Border.all(color: Colors.white24),
    ),
    child: Icon(Icons.graphic_eq_rounded, color: Colors.white, size: size * .6),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.file, {required this.size, this.border});
  final String file;
  final double size;
  final Color? border;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: border == null ? EdgeInsets.zero : const EdgeInsets.all(2),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: border == null ? null : Border.all(color: border!, width: 2),
    ),
    child: ClipOval(
      child: Image.asset('assets/images/voice_chat/$file', fit: BoxFit.cover),
    ),
  );
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    ),
  );
}

class _DarkCircle extends StatelessWidget {
  const _DarkCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => IconButton(
    style: IconButton.styleFrom(
      backgroundColor: Colors.white12,
      foregroundColor: Colors.white,
    ),
    onPressed: onTap,
    icon: Icon(icon),
  );
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = Colors.white12,
  });
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ActionBubble extends StatelessWidget {
  const _ActionBubble({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
        ],
      ),
    ),
  );
}

class _GiftItem extends StatelessWidget {
  const _GiftItem({
    required this.emoji,
    required this.name,
    required this.coins,
    required this.onTap,
  });
  final String emoji, name;
  final int coins;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 31)),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '🪙 $coins',
          style: const TextStyle(color: Color(0xFFFFD36A), fontSize: 9),
        ),
      ],
    ),
  );
}

class _StackedAvatars extends StatelessWidget {
  const _StackedAvatars();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 67,
    height: 29,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          child: _Avatar('profile_sara.jpg', size: 29, border: Colors.white),
        ),
        Positioned(
          left: 19,
          child: _Avatar('profile_ryan.jpg', size: 29, border: Colors.white),
        ),
        Positioned(
          left: 38,
          child: _Avatar('profile_nina.jpg', size: 29, border: Colors.white),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});
  final String title, action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: _purple,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _PartyNavIcon extends StatelessWidget {
  const _PartyNavIcon();
  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 38,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [_purple, _pink]),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.mic_rounded, color: Colors.white),
  );
}

class _PartyTile extends StatelessWidget {
  const _PartyTile(this.emoji, this.title, this.subtitle, this.colors);
  final String emoji, title, subtitle;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, _fade(const _VoiceRoomPage())),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 38)),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class _VsBadge extends StatelessWidget {
  const _VsBadge();
  @override
  Widget build(BuildContext context) => Container(
    width: 58,
    height: 58,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFC83D), Color(0xFFFF4D69)],
      ),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 15)],
    ),
    child: const Text(
      'VS',
      style: TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
    ],
  );
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value, label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
          ],
        ),
      ],
    ),
  );
}

class _VipBenefit extends StatelessWidget {
  const _VipBenefit(this.emoji, this.text);
  final String emoji, text;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(emoji, style: const TextStyle(fontSize: 28)),
      const SizedBox(height: 5),
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 10)),
    ],
  );
}

class _Plan extends StatelessWidget {
  const _Plan(this.name, this.price, this.selected);
  final String name, price;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: selected ? const Color(0x33FFC447) : Colors.white10,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: selected ? const Color(0xFFFFC447) : Colors.white12,
        width: 2,
      ),
    ),
    child: Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: selected ? const Color(0xFFFFD45D) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          price,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    ),
  );
}

PageRouteBuilder<T> _fade<T>(Widget page) => PageRouteBuilder<T>(
  pageBuilder: (_, a, __) => page,
  transitionsBuilder: (_, a, __, child) =>
      FadeTransition(opacity: a, child: child),
  transitionDuration: const Duration(milliseconds: 350),
);
void _toast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
