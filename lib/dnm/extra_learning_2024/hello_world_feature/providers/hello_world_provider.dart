import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hello_world_provider.g.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
//
// Riverpod 3 (riverpod_generator 4): the generator no longer emits a
// per-provider Ref typedef (e.g. HelloWorld2024Ref). Use the base [Ref]
// type from riverpod_annotation instead.
@riverpod
String helloWorld2024(Ref ref) {
  return 'Hello world 2024';
}
