// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unauthorized_signal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnauthorizedSignal)
final unauthorizedSignalProvider = UnauthorizedSignalProvider._();

final class UnauthorizedSignalProvider
    extends $NotifierProvider<UnauthorizedSignal, int> {
  UnauthorizedSignalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unauthorizedSignalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unauthorizedSignalHash();

  @$internal
  @override
  UnauthorizedSignal create() => UnauthorizedSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unauthorizedSignalHash() =>
    r'ad81763ca73e83d63fd7758a0e09f361ef9f707b';

abstract class _$UnauthorizedSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
