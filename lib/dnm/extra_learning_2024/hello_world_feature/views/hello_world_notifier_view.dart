import 'package:flutter/material.dart';
import 'package:flutter_application_1/dnm/extra_learning_2024/hello_world_feature/providers/hello_world_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class HelloWorldNotifierExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorld2024Provider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value + " Hi"),
        ),
      ),
    );
  }
}
