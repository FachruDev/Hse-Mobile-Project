// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  department: json['department'] == null
      ? null
      : UserDepartment.fromJson(json['department'] as Map<String, dynamic>),
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'email': instance.email,
  'name': instance.name,
  'department': instance.department,
  'roles': instance.roles,
  'permissions': instance.permissions,
};

_UserDepartment _$UserDepartmentFromJson(Map<String, dynamic> json) =>
    _UserDepartment(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserDepartmentToJson(_UserDepartment instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
