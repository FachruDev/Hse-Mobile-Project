// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'b3_storage_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$B3StorageDraft {

 String get movementDate; String get movementTime; String get movementType; int? get wasteTypeId; String? get wasteTypeOther; int? get initiatorDepartmentId; String? get initiatorDepartmentOther; String? get initiatorUserName; String? get weightKg; String? get documentNumber; String? get photoPath; String? get note;
/// Create a copy of B3StorageDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$B3StorageDraftCopyWith<B3StorageDraft> get copyWith => _$B3StorageDraftCopyWithImpl<B3StorageDraft>(this as B3StorageDraft, _$identity);

  /// Serializes this B3StorageDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is B3StorageDraft&&(identical(other.movementDate, movementDate) || other.movementDate == movementDate)&&(identical(other.movementTime, movementTime) || other.movementTime == movementTime)&&(identical(other.movementType, movementType) || other.movementType == movementType)&&(identical(other.wasteTypeId, wasteTypeId) || other.wasteTypeId == wasteTypeId)&&(identical(other.wasteTypeOther, wasteTypeOther) || other.wasteTypeOther == wasteTypeOther)&&(identical(other.initiatorDepartmentId, initiatorDepartmentId) || other.initiatorDepartmentId == initiatorDepartmentId)&&(identical(other.initiatorDepartmentOther, initiatorDepartmentOther) || other.initiatorDepartmentOther == initiatorDepartmentOther)&&(identical(other.initiatorUserName, initiatorUserName) || other.initiatorUserName == initiatorUserName)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,movementDate,movementTime,movementType,wasteTypeId,wasteTypeOther,initiatorDepartmentId,initiatorDepartmentOther,initiatorUserName,weightKg,documentNumber,photoPath,note);

@override
String toString() {
  return 'B3StorageDraft(movementDate: $movementDate, movementTime: $movementTime, movementType: $movementType, wasteTypeId: $wasteTypeId, wasteTypeOther: $wasteTypeOther, initiatorDepartmentId: $initiatorDepartmentId, initiatorDepartmentOther: $initiatorDepartmentOther, initiatorUserName: $initiatorUserName, weightKg: $weightKg, documentNumber: $documentNumber, photoPath: $photoPath, note: $note)';
}


}

/// @nodoc
abstract mixin class $B3StorageDraftCopyWith<$Res>  {
  factory $B3StorageDraftCopyWith(B3StorageDraft value, $Res Function(B3StorageDraft) _then) = _$B3StorageDraftCopyWithImpl;
@useResult
$Res call({
 String movementDate, String movementTime, String movementType, int? wasteTypeId, String? wasteTypeOther, int? initiatorDepartmentId, String? initiatorDepartmentOther, String? initiatorUserName, String? weightKg, String? documentNumber, String? photoPath, String? note
});




}
/// @nodoc
class _$B3StorageDraftCopyWithImpl<$Res>
    implements $B3StorageDraftCopyWith<$Res> {
  _$B3StorageDraftCopyWithImpl(this._self, this._then);

  final B3StorageDraft _self;
  final $Res Function(B3StorageDraft) _then;

/// Create a copy of B3StorageDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movementDate = null,Object? movementTime = null,Object? movementType = null,Object? wasteTypeId = freezed,Object? wasteTypeOther = freezed,Object? initiatorDepartmentId = freezed,Object? initiatorDepartmentOther = freezed,Object? initiatorUserName = freezed,Object? weightKg = freezed,Object? documentNumber = freezed,Object? photoPath = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as String,movementTime: null == movementTime ? _self.movementTime : movementTime // ignore: cast_nullable_to_non_nullable
as String,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String,wasteTypeId: freezed == wasteTypeId ? _self.wasteTypeId : wasteTypeId // ignore: cast_nullable_to_non_nullable
as int?,wasteTypeOther: freezed == wasteTypeOther ? _self.wasteTypeOther : wasteTypeOther // ignore: cast_nullable_to_non_nullable
as String?,initiatorDepartmentId: freezed == initiatorDepartmentId ? _self.initiatorDepartmentId : initiatorDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,initiatorDepartmentOther: freezed == initiatorDepartmentOther ? _self.initiatorDepartmentOther : initiatorDepartmentOther // ignore: cast_nullable_to_non_nullable
as String?,initiatorUserName: freezed == initiatorUserName ? _self.initiatorUserName : initiatorUserName // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as String?,documentNumber: freezed == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [B3StorageDraft].
extension B3StorageDraftPatterns on B3StorageDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _B3StorageDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _B3StorageDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _B3StorageDraft value)  $default,){
final _that = this;
switch (_that) {
case _B3StorageDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _B3StorageDraft value)?  $default,){
final _that = this;
switch (_that) {
case _B3StorageDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String movementDate,  String movementTime,  String movementType,  int? wasteTypeId,  String? wasteTypeOther,  int? initiatorDepartmentId,  String? initiatorDepartmentOther,  String? initiatorUserName,  String? weightKg,  String? documentNumber,  String? photoPath,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _B3StorageDraft() when $default != null:
return $default(_that.movementDate,_that.movementTime,_that.movementType,_that.wasteTypeId,_that.wasteTypeOther,_that.initiatorDepartmentId,_that.initiatorDepartmentOther,_that.initiatorUserName,_that.weightKg,_that.documentNumber,_that.photoPath,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String movementDate,  String movementTime,  String movementType,  int? wasteTypeId,  String? wasteTypeOther,  int? initiatorDepartmentId,  String? initiatorDepartmentOther,  String? initiatorUserName,  String? weightKg,  String? documentNumber,  String? photoPath,  String? note)  $default,) {final _that = this;
switch (_that) {
case _B3StorageDraft():
return $default(_that.movementDate,_that.movementTime,_that.movementType,_that.wasteTypeId,_that.wasteTypeOther,_that.initiatorDepartmentId,_that.initiatorDepartmentOther,_that.initiatorUserName,_that.weightKg,_that.documentNumber,_that.photoPath,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String movementDate,  String movementTime,  String movementType,  int? wasteTypeId,  String? wasteTypeOther,  int? initiatorDepartmentId,  String? initiatorDepartmentOther,  String? initiatorUserName,  String? weightKg,  String? documentNumber,  String? photoPath,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _B3StorageDraft() when $default != null:
return $default(_that.movementDate,_that.movementTime,_that.movementType,_that.wasteTypeId,_that.wasteTypeOther,_that.initiatorDepartmentId,_that.initiatorDepartmentOther,_that.initiatorUserName,_that.weightKg,_that.documentNumber,_that.photoPath,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _B3StorageDraft implements B3StorageDraft {
  const _B3StorageDraft({required this.movementDate, required this.movementTime, required this.movementType, this.wasteTypeId, this.wasteTypeOther, this.initiatorDepartmentId, this.initiatorDepartmentOther, this.initiatorUserName, this.weightKg, this.documentNumber, this.photoPath, this.note});
  factory _B3StorageDraft.fromJson(Map<String, dynamic> json) => _$B3StorageDraftFromJson(json);

@override final  String movementDate;
@override final  String movementTime;
@override final  String movementType;
@override final  int? wasteTypeId;
@override final  String? wasteTypeOther;
@override final  int? initiatorDepartmentId;
@override final  String? initiatorDepartmentOther;
@override final  String? initiatorUserName;
@override final  String? weightKg;
@override final  String? documentNumber;
@override final  String? photoPath;
@override final  String? note;

/// Create a copy of B3StorageDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$B3StorageDraftCopyWith<_B3StorageDraft> get copyWith => __$B3StorageDraftCopyWithImpl<_B3StorageDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$B3StorageDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _B3StorageDraft&&(identical(other.movementDate, movementDate) || other.movementDate == movementDate)&&(identical(other.movementTime, movementTime) || other.movementTime == movementTime)&&(identical(other.movementType, movementType) || other.movementType == movementType)&&(identical(other.wasteTypeId, wasteTypeId) || other.wasteTypeId == wasteTypeId)&&(identical(other.wasteTypeOther, wasteTypeOther) || other.wasteTypeOther == wasteTypeOther)&&(identical(other.initiatorDepartmentId, initiatorDepartmentId) || other.initiatorDepartmentId == initiatorDepartmentId)&&(identical(other.initiatorDepartmentOther, initiatorDepartmentOther) || other.initiatorDepartmentOther == initiatorDepartmentOther)&&(identical(other.initiatorUserName, initiatorUserName) || other.initiatorUserName == initiatorUserName)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,movementDate,movementTime,movementType,wasteTypeId,wasteTypeOther,initiatorDepartmentId,initiatorDepartmentOther,initiatorUserName,weightKg,documentNumber,photoPath,note);

@override
String toString() {
  return 'B3StorageDraft(movementDate: $movementDate, movementTime: $movementTime, movementType: $movementType, wasteTypeId: $wasteTypeId, wasteTypeOther: $wasteTypeOther, initiatorDepartmentId: $initiatorDepartmentId, initiatorDepartmentOther: $initiatorDepartmentOther, initiatorUserName: $initiatorUserName, weightKg: $weightKg, documentNumber: $documentNumber, photoPath: $photoPath, note: $note)';
}


}

/// @nodoc
abstract mixin class _$B3StorageDraftCopyWith<$Res> implements $B3StorageDraftCopyWith<$Res> {
  factory _$B3StorageDraftCopyWith(_B3StorageDraft value, $Res Function(_B3StorageDraft) _then) = __$B3StorageDraftCopyWithImpl;
@override @useResult
$Res call({
 String movementDate, String movementTime, String movementType, int? wasteTypeId, String? wasteTypeOther, int? initiatorDepartmentId, String? initiatorDepartmentOther, String? initiatorUserName, String? weightKg, String? documentNumber, String? photoPath, String? note
});




}
/// @nodoc
class __$B3StorageDraftCopyWithImpl<$Res>
    implements _$B3StorageDraftCopyWith<$Res> {
  __$B3StorageDraftCopyWithImpl(this._self, this._then);

  final _B3StorageDraft _self;
  final $Res Function(_B3StorageDraft) _then;

/// Create a copy of B3StorageDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movementDate = null,Object? movementTime = null,Object? movementType = null,Object? wasteTypeId = freezed,Object? wasteTypeOther = freezed,Object? initiatorDepartmentId = freezed,Object? initiatorDepartmentOther = freezed,Object? initiatorUserName = freezed,Object? weightKg = freezed,Object? documentNumber = freezed,Object? photoPath = freezed,Object? note = freezed,}) {
  return _then(_B3StorageDraft(
movementDate: null == movementDate ? _self.movementDate : movementDate // ignore: cast_nullable_to_non_nullable
as String,movementTime: null == movementTime ? _self.movementTime : movementTime // ignore: cast_nullable_to_non_nullable
as String,movementType: null == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String,wasteTypeId: freezed == wasteTypeId ? _self.wasteTypeId : wasteTypeId // ignore: cast_nullable_to_non_nullable
as int?,wasteTypeOther: freezed == wasteTypeOther ? _self.wasteTypeOther : wasteTypeOther // ignore: cast_nullable_to_non_nullable
as String?,initiatorDepartmentId: freezed == initiatorDepartmentId ? _self.initiatorDepartmentId : initiatorDepartmentId // ignore: cast_nullable_to_non_nullable
as int?,initiatorDepartmentOther: freezed == initiatorDepartmentOther ? _self.initiatorDepartmentOther : initiatorDepartmentOther // ignore: cast_nullable_to_non_nullable
as String?,initiatorUserName: freezed == initiatorUserName ? _self.initiatorUserName : initiatorUserName // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as String?,documentNumber: freezed == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
