import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_user.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    @Default(false) bool isAuthenticated,
    AppUser? user,
  }) = _AuthSession;

  factory AuthSession.authenticated({required AppUser user}) {
    return AuthSession(isAuthenticated: true, user: user);
  }
}
