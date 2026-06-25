// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_world_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(helloWorld2024)
final helloWorld2024Provider = HelloWorld2024Provider._();

final class HelloWorld2024Provider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  HelloWorld2024Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'helloWorld2024Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$helloWorld2024Hash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return helloWorld2024(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$helloWorld2024Hash() => r'49f1487c0f39e2bb00390efdcc3650a1a43ed140';
