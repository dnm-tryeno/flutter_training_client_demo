import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod 3: [StateNotifier] was removed in favor of [Notifier]. Initial
// state is exposed via [build] rather than the constructor.
class RandomNumberGenerator extends Notifier<int> {
  @override
  int build() => Random().nextInt(9999);

  void generate() {
    state = Random().nextInt(9999);
  }
}

// Notifier provider holding the state.
final randomNumberProvider =
    NotifierProvider<RandomNumberGenerator, int>(RandomNumberGenerator.new);

class RandomNumberApp extends StatelessWidget {
  const RandomNumberApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Random number'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RandomConsumer(),
              // Consumer to call a method inside StateNotifier just to change
              // the state
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                      child: const Text('Generate'),
                      onPressed: () {
                        // ref.read(randomNumberProvider.notifier).generate(),
                        //using variable
                        var b = ref.read(randomNumberProvider.notifier);
                        b.generate();
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        debugPrint("generated random number..${b.state}");
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Custom consumer using the provider
class RandomConsumer extends ConsumerWidget {
  const RandomConsumer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.watch(randomNumberProvider).toString());
  }
}
