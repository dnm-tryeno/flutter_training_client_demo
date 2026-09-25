import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _ink = Color(0xFF10130F);
const _lime = Color(0xFFC8F04B);
const _paper = Color(0xFFF4F5EF);
const _muted = Color(0xFF6C7167);

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitCore',
      theme: base.copyWith(
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _lime, primary: _ink),
        textTheme: GoogleFonts.manropeTextTheme(
          base.textTheme,
        ).apply(bodyColor: _ink, displayColor: _ink),
      ),
      home: const _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  bool obscure = true;

  void _open(Widget page) => Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: page,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _ink,
    body: SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 290,
              height: 290,
              decoration: const BoxDecoration(
                color: _lime,
                shape: BoxShape.circle,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt_rounded, color: _lime, size: 30),
                  Text(
                    'FITCORE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 76),
              const Text(
                'STRONGER\nEVERY DAY.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  height: .93,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2.5,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Your training, nutrition and membership—\nfinally in one place.',
                style: TextStyle(color: Colors.white60, height: 1.5),
              ),
              const SizedBox(height: 38),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: _loginDecoration(
                  'Phone or member ID',
                  Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: obscure,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _loginDecoration(
                      'Password',
                      Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white54,
                        ),
                      ),
                    ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showInfoSheet(
                    context,
                    'Reset password',
                    'We will send a secure reset link to your registered WhatsApp number.',
                    Icons.lock_reset_rounded,
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: _lime),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _lime,
                    foregroundColor: _ink,
                  ),
                  onPressed: () => _open(const _GymShell()),
                  child: const Text(
                    'Login as member',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                  onPressed: () => _open(const _AdminPage()),
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text('View admin demo'),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'Demo login · Any credentials work',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  InputDecoration _loginDecoration(String hint, IconData icon) =>
      InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white54),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .07),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _lime),
        ),
      );
}

class _GymShell extends StatefulWidget {
  const _GymShell();
  @override
  State<_GymShell> createState() => _GymShellState();
}

class _GymShellState extends State<_GymShell> {
  int index = 0;
  final pages = const [
    _HomePage(),
    _WorkoutPage(),
    _TrainersPage(),
    _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(.025, .02),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(index), child: pages[index]),
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE3E5DC))),
      ),
      child: NavigationBar(
        height: 72,
        backgroundColor: Colors.white,
        indicatorColor: _lime,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Train',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_2_outlined),
            label: 'Coaches',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );
}

class _TopBar extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Widget? trailing;
  const _TopBar(this.eyebrow, this.title, {this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.8,
                  color: _muted,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 27,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
            ],
          ),
        ),
        trailing ?? const _Avatar(),
      ],
    ),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar();
  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white, width: 2),
      image: const DecorationImage(
        image: AssetImage('assets/images/gym/member.jpg'),
        fit: BoxFit.cover,
      ),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
    ),
  );
}

class _HomePage extends StatefulWidget {
  const _HomePage();
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  bool checkedIn = false;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.only(bottom: 22),
      children: [
        _TopBar('Tuesday · 15 Sep', 'Let’s get stronger, Riya'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _MembershipCard(onTap: () => _renewSheet(context)),
              const SizedBox(height: 14),
              _StreakCard(
                checkedIn: checkedIn,
                onCheck: () => setState(() => checkedIn = true),
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                'Today’s plan',
                action: 'View schedule',
                onTap: () => _showSchedule(context),
              ),
              const SizedBox(height: 12),
              const _TodayWorkout(),
              const SizedBox(height: 24),
              _SectionTitle(
                'Daily nutrition',
                action: 'Calculate',
                onTap: () => _calculatorSheet(context),
              ),
              const SizedBox(height: 12),
              const _NutritionCard(),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MembershipCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MembershipCard({required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _ink,
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x3310130F),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _lime,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PRO MEMBER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.bolt_rounded, color: _lime),
            const Text(
              ' FITCORE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEMBERSHIP VALID TILL',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '22 Sep 2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '7 days remaining',
                    style: TextStyle(
                      color: _lime,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _ink,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
              label: const Text('Renew'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _StreakCard extends StatelessWidget {
  final bool checkedIn;
  final VoidCallback onCheck;
  const _StreakCard({required this.checkedIn, required this.onCheck});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFE5E7DF)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEE5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF6534),
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '12 day streak',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Your best: 18 days',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: checkedIn ? null : onCheck,
              child: Text(checkedIn ? 'Done ✓' : 'Check in'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final active = i < (checkedIn ? 7 : 6);
            return Column(
              children: [
                Text(
                  ['W', 'T', 'F', 'S', 'S', 'M', 'T'][i],
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                    color: active ? _lime : const Color(0xFFEEEFE9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    active ? Icons.check_rounded : Icons.more_horiz,
                    size: 17,
                    color: active ? _ink : Colors.black26,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

class _TodayWorkout extends StatelessWidget {
  const _TodayWorkout();
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _startWorkout(context, 'Chest & Shoulders'),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 205,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/gym/chest.jpg', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE610130F)],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 17,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PUSH DAY · 55 MIN',
                          style: TextStyle(
                            color: _lime,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Chest & Shoulders',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '6 exercises  •  Intermediate',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: _lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard();
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Calories', '2,240', 'kcal', .66, Color(0xFFEF6A45)),
      ('Protein', '142', 'g', .78, Color(0xFF8157D9)),
      ('Carbs', '265', 'g', .60, Color(0xFF45A17A)),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7DF)),
      ),
      child: Row(
        children: items
            .map(
              (x) => Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 58,
                      height: 58,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: x.$4,
                            strokeWidth: 6,
                            backgroundColor: x.$5.withValues(alpha: .13),
                            color: x.$5,
                            strokeCap: StrokeCap.round,
                          ),
                          Text(
                            '${(x.$4 * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      x.$1,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                    Text(
                      '${x.$2} ${x.$3}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _WorkoutPage extends StatefulWidget {
  const _WorkoutPage();
  @override
  State<_WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<_WorkoutPage> {
  int selected = 0;
  final days = const ['Shoulders', 'Legs', 'Back', 'Chest', 'Arms'];
  final workouts = const [
    [
      (
        'Barbell overhead press',
        '4 sets · 8–10 reps',
        'assets/images/gym/shoulder.jpg',
      ),
      (
        'Lateral dumbbell raise',
        '3 sets · 12–15 reps',
        'assets/images/gym/shoulder.jpg',
      ),
      ('Face pulls', '3 sets · 15 reps', 'assets/images/gym/shoulder.jpg'),
      ('Arnold press', '3 sets · 10 reps', 'assets/images/gym/shoulder.jpg'),
    ],
    [
      ('Back squat', '4 sets · 8 reps', 'assets/images/gym/legs.jpg'),
      ('Romanian deadlift', '4 sets · 10 reps', 'assets/images/gym/legs.jpg'),
      ('Walking lunges', '3 sets · 12 reps', 'assets/images/gym/legs.jpg'),
    ],
  ];
  @override
  Widget build(BuildContext context) {
    final list = workouts[selected == 1 ? 1 : 0];
    return SafeArea(
      child: Column(
        children: [
          const _TopBar('Training library', 'Build your week'),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(days[i]),
                selected: selected == i,
                selectedColor: _ink,
                labelStyle: TextStyle(
                  color: selected == i ? Colors.white : _ink,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => setState(() => selected = i),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _lime,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${days[selected]} day',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${list.length} exercises · 48 min',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.sports_gymnastics_rounded, size: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...list.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ExerciseTile(number: e.key + 1, data: e.value),
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

class _ExerciseTile extends StatelessWidget {
  final int number;
  final (String, String, String) data;
  const _ExerciseTile({required this.number, required this.data});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showExercise(context, data),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                data.$3,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.black12,
                  child: const Icon(Icons.fitness_center),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$number. ${data.$1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.$2,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _muted),
          ],
        ),
      ),
    ),
  );
}

class _TrainersPage extends StatelessWidget {
  const _TrainersPage();
  @override
  Widget build(BuildContext context) {
    const trainers = [
      (
        'Kabir Singh',
        'Strength & Conditioning',
        '4.9',
        'assets/images/gym/trainer_kabir.jpg',
      ),
      (
        'Meera Rao',
        'Fat loss · Mobility',
        '4.8',
        'assets/images/gym/trainer_meera.jpg',
      ),
      (
        'Arjun Dev',
        'Bodybuilding',
        '4.9',
        'assets/images/gym/trainer_arjun.jpg',
      ),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const _TopBar('Expert guidance', 'Find your trainer'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search trainer or specialty',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...trainers.map(
            (t) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      child: Image.asset(
                        t.$4,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.$1,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  t.$2,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFFF4B63E),
                                      size: 18,
                                    ),
                                    Text(
                                      ' ${t.$3}  ·  120+ sessions',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Trial request sent to ${t.$1}',
                                    ),
                                  ),
                                ),
                            child: const Text('Book'),
                          ),
                        ],
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

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _TopBar(
          'Member ID · FC2048',
          'Your profile',
          trailing: IconButton.filledTonal(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _AdminPage()),
            ),
            icon: const Icon(Icons.admin_panel_settings_outlined),
          ),
        ),
        const SizedBox(height: 8),
        const Center(child: _Avatar()),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Riya Sharma',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ),
        const Center(
          child: Text(
            'Pro member since March 2025',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Expanded(child: _Stat('58 kg', 'Weight')),
              SizedBox(width: 10),
              Expanded(child: _Stat('164 cm', 'Height')),
              SizedBox(width: 10),
              Expanded(child: _Stat('21.6', 'BMI')),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            child: Column(
              children: [
                _Menu(
                  Icons.workspace_premium_outlined,
                  'My membership',
                  'Expires in 7 days',
                  onTap: () => _renewSheet(context),
                ),
                const Divider(height: 1, indent: 56),
                _Menu(
                  Icons.notifications_none_rounded,
                  'Reminders',
                  'WhatsApp enabled',
                  onTap: () => _showInfoSheet(
                    context,
                    'Smart reminders',
                    'Workout: 6:00 PM\nMembership renewal: 7 days before expiry\nChannel: WhatsApp',
                    Icons.notifications_active_outlined,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _Menu(
                  Icons.monitor_weight_outlined,
                  'Body & nutrition',
                  'Update measurements',
                  onTap: () => _calculatorSheet(context),
                ),
                const Divider(height: 1, indent: 56),
                _Menu(
                  Icons.admin_panel_settings_outlined,
                  'Open admin demo',
                  'Manage gym data',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const _AdminPage()),
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

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: _muted, fontSize: 11)),
      ],
    ),
  );
}

class _Menu extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  const _Menu(this.icon, this.title, this.subtitle, {this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
    trailing: const Icon(Icons.chevron_right_rounded),
  );
}

class _AdminPage extends StatelessWidget {
  const _AdminPage();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF111411),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      title: const Text(
        'Gym Admin',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      actions: [
        IconButton(
          onPressed: () => _showInfoSheet(
            context,
            'Admin notifications',
            '11 memberships expire this week\n3 payments need review\n32 members checked in today',
            Icons.notifications_active_rounded,
          ),
          icon: const Badge(child: Icon(Icons.notifications_none_rounded)),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Good morning, Admin',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const Text(
          'Here’s your gym today.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(
              child: _AdminStat('248', 'Members', Icons.groups_2_rounded),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _AdminStat('₹1.84L', 'Revenue', Icons.trending_up_rounded),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: _AdminStat('32', 'Checked in', Icons.login_rounded),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _AdminStat('11', 'Expiring', Icons.schedule_rounded),
            ),
          ],
        ),
        const SizedBox(height: 25),
        _SectionTitle(
          'Expiring this week',
          action: 'See all',
          dark: true,
          onTap: () => _showInfoSheet(
            context,
            'All expiring members',
            '11 active memberships are due for renewal within the next 7 days.',
            Icons.manage_accounts_outlined,
          ),
        ),
        const SizedBox(height: 12),
        ...[
          ('Riya Sharma', '22 Sep · Pro plan'),
          ('Nikhil Das', '19 Sep · Quarterly'),
          ('Aman Jain', '20 Sep · Monthly'),
        ].map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: const Color(0xFF1C201B),
              borderRadius: BorderRadius.circular(18),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _lime,
                  child: Text(
                    m.$1[0],
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: Text(
                  m.$1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  m.$2,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                trailing: IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('WhatsApp reminder queued for ${m.$1}'),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, color: _lime),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const _SectionTitle('Quick manage', dark: true),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: const [
            _AdminAction(Icons.person_add_alt_1_rounded, 'Add member'),
            _AdminAction(Icons.fitness_center, 'Workouts'),
            _AdminAction(Icons.badge_outlined, 'Trainers'),
            _AdminAction(Icons.analytics_outlined, 'Reports'),
          ],
        ),
      ],
    ),
  );
}

class _AdminStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _AdminStat(this.value, this.label, this.icon);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1C201B),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _lime),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    ),
  );
}

class _AdminAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AdminAction(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF1C201B),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label opened'))),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: _lime),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  final bool dark;
  const _SectionTitle(this.title, {this.action, this.onTap, this.dark = false});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            color: dark ? Colors.white : _ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      if (action != null)
        GestureDetector(
          onTap: onTap,
          child: Text(
            action!,
            style: TextStyle(
              color: dark ? _lime : _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
    ],
  );
}

void _showInfoSheet(
  BuildContext context,
  String title,
  String message,
  IconData icon,
) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 22),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: _lime,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, height: 1.6),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _ink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$title completed')));
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    ),
  ),
);

void _showSchedule(BuildContext context) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
    decoration: const BoxDecoration(
      color: _paper,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Weekly schedule',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        ...[
          ('Today', 'Chest & Shoulders', true),
          ('Wednesday', 'Active recovery', false),
          ('Thursday', 'Leg day', false),
          ('Friday', 'Back & Biceps', false),
        ].map(
          (day) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: day.$3 ? _lime : Colors.white,
              child: Icon(
                day.$3
                    ? Icons.play_arrow_rounded
                    : Icons.calendar_today_outlined,
                color: _ink,
                size: 19,
              ),
            ),
            title: Text(
              day.$1,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(day.$2),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.pop(context);
              _startWorkout(context, day.$2);
            },
          ),
        ),
      ],
    ),
  ),
);

void _startWorkout(BuildContext context, String title) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    icon: const Icon(Icons.timer_outlined, size: 38),
    title: Text(title, textAlign: TextAlign.center),
    content: const Text(
      'Timer is ready. Your first exercise begins with a 60-second warm-up.',
      textAlign: TextAlign.center,
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Not now'),
      ),
      FilledButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workout started — keep going!')),
          );
        },
        child: const Text('Start workout'),
      ),
    ],
  ),
);

void _showExercise(
  BuildContext context,
  (String, String, String) data,
) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Image.asset(
            data.$3,
            width: double.infinity,
            height: 190,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Text(
                data.$1,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(data.$2, style: const TextStyle(color: _muted)),
              const SizedBox(height: 15),
              const Text(
                'Keep your core braced, use a controlled range of motion and stop if you feel sharp pain.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _startWorkout(context, data.$1);
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start exercise'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

void _calculatorSheet(BuildContext context) {
  double weight = 58, height = 164, age = 26;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (context, setSheet) {
        final bmr = 10 * weight + 6.25 * height - 5 * age - 161;
        final calories = (bmr * 1.55).round();
        final protein = (weight * 1.8).round();
        return Container(
          padding: EdgeInsets.fromLTRB(
            22,
            14,
            22,
            MediaQuery.viewInsetsOf(context).bottom + 25,
          ),
          decoration: const BoxDecoration(
            color: _paper,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Your nutrition target',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const Text(
                'Based on the Mifflin-St Jeor estimate',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              _MetricSlider(
                'Weight',
                weight,
                40,
                120,
                'kg',
                (v) => setSheet(() => weight = v),
              ),
              _MetricSlider(
                'Height',
                height,
                140,
                200,
                'cm',
                (v) => setSheet(() => height = v),
              ),
              _MetricSlider(
                'Age',
                age,
                16,
                70,
                'yr',
                (v) => setSheet(() => age = v),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _ink,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(child: _Result('$calories', 'kcal/day')),
                    Container(width: 1, height: 36, color: Colors.white24),
                    Expanded(child: _Result('$protein g', 'protein/day')),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _lime,
                    foregroundColor: _ink,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Save my plan',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _MetricSlider extends StatelessWidget {
  final String label, unit;
  final double value, min, max;
  final ValueChanged<double> onChanged;
  const _MetricSlider(
    this.label,
    this.value,
    this.min,
    this.max,
    this.unit,
    this.onChanged,
  );
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(
            '${value.round()} $unit',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        activeColor: _ink,
        onChanged: onChanged,
      ),
    ],
  );
}

class _Result extends StatelessWidget {
  final String value, label;
  const _Result(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: _lime,
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
    ],
  );
}

void _renewSheet(BuildContext context) => showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Scan & renew',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const Text(
          'Pro yearly plan · ₹12,999',
          style: TextStyle(color: _muted),
        ),
        const SizedBox(height: 18),
        Container(
          width: 210,
          height: 210,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: _paper,
            borderRadius: BorderRadius.circular(25),
          ),
          child: CustomPaint(painter: _QrPainter()),
        ),
        const SizedBox(height: 12),
        const Text(
          'Scan with any UPI app',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const Text(
          'Secure payment · Instant activation',
          style: TextStyle(color: _muted, fontSize: 11),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment link copied')),
              );
            },
            icon: const Icon(Icons.link),
            label: const Text('Copy payment link'),
          ),
        ),
      ],
    ),
  ),
);

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = _ink;
    const n = 13;
    final d = s.width / n;
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (((x * y + x + y * 3) % 5 < 2) || _finder(x, y, n)) {
          c.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x * d, y * d, d * .82, d * .82),
              Radius.circular(d * .12),
            ),
            p,
          );
        }
      }
    }
  }

  bool _finder(int x, int y, int n) =>
      ((x < 4 && y < 4) || (x > n - 5 && y < 4) || (x < 4 && y > n - 5)) &&
      (math.max(x % 9, y % 9) != 2);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
