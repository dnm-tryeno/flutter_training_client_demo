import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod 3: StateProvider was removed.
// Use a NotifierProvider that exposes a counter with an increment method.
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
}

final counterProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

//final cunterProvider = StateProvider((ref)=>0 );
void main() {
  //ProviderScope is a widget that stores
  //the state of all the providers we create.
  runApp(const ProviderScope(child: MyWidget()));
}

class MyWidget extends ConsumerWidget {
  const MyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('State provider')),
            body: Align(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text('$counter', textAlign: TextAlign.center),
                    ),
                    FloatingActionButton(
                        child: Text("+"),
                        onPressed: () {
                          ref.read(counterProvider.notifier).increment();
                        }),
                  ]),
            )));
  }
}
