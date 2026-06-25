// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class counter extends StatelessWidget {
  const counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

/// Providers are declared globally and specify how to create a state.
/// Riverpod 3: [StateProvider] was removed. Use a [NotifierProvider] instead.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
}

final counterProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        // Consumer is a widget that allows you reading providers.
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider);
          debugPrintThrottled("watching..... ${count}");
          return Text('$count');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it.
        onPressed: () {
          ref.read(counterProvider.notifier).increment();
          debugPrint("count Value  ${ref.read(counterProvider)}");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
