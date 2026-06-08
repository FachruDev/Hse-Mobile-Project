import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    required String name,
    UserDepartment? department,
    @Default(<String>[]) List<String> roles,
    @Default(<String>[]) List<String> permissions,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  bool hasPermission(String permission) => permissions.contains(permission);

  bool hasAnyPermission(Iterable<String> requiredPermissions) {
    return requiredPermissions.any(hasPermission);
  }
}

@freezed
abstract class UserDepartment with _$UserDepartment {
  const factory UserDepartment({required int id, required String name}) =
      _UserDepartment;

  factory UserDepartment.fromJson(Map<String, dynamic> json) =>
      _$UserDepartmentFromJson(json);
}
