// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// https://youtu.be/U_9yhp0aSaQ
void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Riverpod 3: StateProvider was removed. Use a NotifierProvider instead.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
  void decrement() => state = state - 1;
}

final counterStateProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var value = ref.watch(counterStateProvider);
    return Scaffold(
      body: Center(
        child: Text(
          'value:$value',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: () {
                ref.read(counterStateProvider.notifier).increment();
                debugPrint("Value of ${ref.read(counterStateProvider)}");
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.pink,
            ),
            FloatingActionButton(
              onPressed: () =>
                  ref.read(counterStateProvider.notifier).decrement(),
              child: const Icon(Icons.remove),
              backgroundColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
