// dependencies: flutter_riverpod: ^3.2.1

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod 3: StateProvider was removed. Use a NotifierProvider instead.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
}

final counterStateProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. watch the counterStateProvider
    final counter = ref.watch(counterStateProvider);
    return Scaffold(
      body: Center(
        child: Text(
          // 2. use the counter value
          'Value: $counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
