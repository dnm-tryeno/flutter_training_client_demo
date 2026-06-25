# Demos Launcher — Plan

A single launcher app that lists many demos (TikTok-style, others). Tapping a tile opens a **completely separate demo app** that owns its own theme, colors, navigation, and state. Editing one demo cannot affect any other demo.

---

## 1. Goal

- One **home page** with a grid/list of buttons — each button = one demo.
- Tap a button → push a route that mounts that demo as if it were its own app (its own `MaterialApp`, own theme, own routes).
- Demos are **isolated**: own folder, own theme file, own widgets. No shared mutable state.
- Adding a new demo = add one folder + register one entry in a list. Nothing else changes.

---

## 2. Folder Structure

```
lib/
  main.dart                  # runs LauncherApp
  launcher/
    launcher_app.dart        # MaterialApp for the home/launcher
    home_page.dart           # grid of demo tiles
    demo_registry.dart       # the list of all demos (single source of truth)
    demo_entry.dart          # DemoEntry model: title, icon, builder
  demos/
    tiktok/
      tiktok_app.dart        # entry widget — wraps its own MaterialApp + theme
      theme.dart             # colors, text styles for THIS demo only
      pages/
      widgets/
    instagram/
      instagram_app.dart
      theme.dart
      pages/
    chat/
      chat_app.dart
      theme.dart
      pages/
```

Existing per-person folders (`dnm/`, `anita/`, `jinal/`, ...) stay where they are. The launcher can also point at demos living in those folders — the registry just needs a builder function.

---

## 3. The "Each Demo Is Its Own App" Trick

Each demo exports **one widget** that returns its own `MaterialApp`. When the launcher pushes it, it sits inside the parent `MaterialApp` but with a **nested `MaterialApp`** it gets its own theme, navigator, and routes.

```dart
// demos/tiktok/tiktok_app.dart
class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tikTokTheme,            // from theme.dart in this folder
      home: const TikTokFeedPage(),
    );
  }
}
```

```dart
// demos/tiktok/theme.dart
final tikTokTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFE2C55),
    secondary: Color(0xFF25F4EE),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
```

Because the theme lives **inside the demo folder**, editing TikTok colors cannot touch Instagram colors. Same for routes, fonts, dialogs, snackbars.

---

## 4. Registering Demos

One file lists every demo. Adding a demo = one new line here.

```dart
// launcher/demo_entry.dart
class DemoEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder; // returns the demo's root widget

  const DemoEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
}
```

```dart
// launcher/demo_registry.dart
import '../demos/tiktok/tiktok_app.dart';
import '../demos/instagram/instagram_app.dart';
import '../demos/chat/chat_app.dart';

final demos = <DemoEntry>[
  DemoEntry(
    title: 'TikTok',
    subtitle: 'Vertical video feed',
    icon: Icons.music_video,
    builder: (_) => const TikTokApp(),
  ),
  DemoEntry(
    title: 'Instagram',
    subtitle: 'Photo feed + stories',
    icon: Icons.camera_alt,
    builder: (_) => const InstagramApp(),
  ),
  DemoEntry(
    title: 'Chat',
    subtitle: 'WhatsApp-style chat',
    icon: Icons.chat_bubble,
    builder: (_) => const ChatApp(),
  ),
];
```

---

## 5. Home Page

```dart
// launcher/home_page.dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demos')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: demos.length,
        itemBuilder: (context, i) {
          final d = demos[i];
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: d.builder),
            ),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(d.icon, size: 48),
                  const SizedBox(height: 8),
                  Text(d.title),
                  Text(d.subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 6. Launcher App + main.dart

```dart
// launcher/launcher_app.dart
class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Training Demos',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}
```

```dart
// main.dart
import 'package:flutter/material.dart';
import 'launcher/launcher_app.dart';

void main() => runApp(const LauncherApp());
```

---

## 7. Rules to Keep Demos Isolated

- Each demo folder **never imports** from another demo folder.
- Shared things (e.g. a generic button) go in `lib/shared/` — and must be **stateless and styled by parent theme**, never carry hardcoded brand colors.
- Each demo defines its **own** `theme.dart`, `routes`, `models`, `state`.
- If a demo needs state management (Provider / Riverpod / Bloc), wrap **only that demo** in the scope — not the launcher.
  Example: `builder: (_) => ProviderScope(child: const ChatApp())`
- Each demo should compile and run alone if you point `main.dart` at it directly (good for focused dev).

---

## 8. Adding a New Demo — Checklist

1. Create `lib/demos/<name>/`.
2. Add `theme.dart` and `<name>_app.dart` (returns its own `MaterialApp`).
3. Build pages/widgets inside that folder only.
4. Add one `DemoEntry` to `lib/launcher/demo_registry.dart`.
5. Done — home page picks it up automatically.

---

## 9. First Demos to Build

| Demo       | Why it's a good practice                         |
|------------|--------------------------------------------------|
| TikTok     | `PageView` vertical, video, overlay UI, dark theme |
| Instagram  | Feed + stories row, image-heavy layout           |
| Chat       | `ListView.builder`, bubbles, text input          |
| Weather    | API call, async state, custom theming            |
| Calculator | State, grid layout, simple logic                 |

Start with TikTok since you mentioned it.
