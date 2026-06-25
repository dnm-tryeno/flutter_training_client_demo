import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod 3: StateProvider was removed. Migrated to a NotifierProvider.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
  void reset() => state = 0;
}

final counterProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

void main() {
  debugPrint("Run App");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Go to Counter Page");
    return MaterialApp(
      title: 'Counter App',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
          surface: const Color(0xff003909),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Go to Home Page ");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text('Go to Counter Page'),
        onPressed: () {
          debugPrint("Go to Counter Page");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const CounterPage()),
            ),
          );
        },
      )),
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("on press back button go to home page");
    final int counter = ref.watch(counterProvider);

    ref.listen<int>(
      counterProvider,
      (previous, next) {
        if (next >= 5) {
          showDialog(
            context: context,
            builder: (context) {
              debugPrint("if value >= 5 then show dialog box");
              return AlertDialog(
                title: const Text("Warning"),
                content: const Text(
                    "Counter dangerously high. Consider resetting it."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            },
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint("on press reset button increment value 0");
              ref.read(counterProvider.notifier).reset();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Text(
          counter.toString(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          debugPrint("on press + increment value");
          ref.read(counterProvider.notifier).increment();
        },
      ),
    );
  }
}
