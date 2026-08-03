// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthSessionController)
final authSessionControllerProvider = AuthSessionControllerProvider._();

final class AuthSessionControllerProvider
    extends $AsyncNotifierProvider<AuthSessionController, AuthSession> {
  AuthSessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionControllerHash();

  @$internal
  @override
  AuthSessionController create() => AuthSessionController();
}

String _$authSessionControllerHash() =>
    r'ca60a706ef4973dfef4bf3daf519c693b387ca18';

abstract class _$AuthSessionController extends $AsyncNotifier<AuthSession> {
  FutureOr<AuthSession> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthSession>, AuthSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSession>, AuthSession>,
              AsyncValue<AuthSession>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'a6234cd57716bfa85e03cc50981d799d7c42d320';
