// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'b3_master_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$B3MasterOption {

 int get id; String get name;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'order_no') int? get orderNo;
/// Create a copy of B3MasterOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$B3MasterOptionCopyWith<B3MasterOption> get copyWith => _$B3MasterOptionCopyWithImpl<B3MasterOption>(this as B3MasterOption, _$identity);

  /// Serializes this B3MasterOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is B3MasterOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,orderNo);

@override
String toString() {
  return 'B3MasterOption(id: $id, name: $name, isActive: $isActive, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class $B3MasterOptionCopyWith<$Res>  {
  factory $B3MasterOptionCopyWith(B3MasterOption value, $Res Function(B3MasterOption) _then) = _$B3MasterOptionCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'order_no') int? orderNo
});




}
/// @nodoc
class _$B3MasterOptionCopyWithImpl<$Res>
    implements $B3MasterOptionCopyWith<$Res> {
  _$B3MasterOptionCopyWithImpl(this._self, this._then);

  final B3MasterOption _self;
  final $Res Function(B3MasterOption) _then;

/// Create a copy of B3MasterOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? orderNo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [B3MasterOption].
extension B3MasterOptionPatterns on B3MasterOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _B3MasterOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _B3MasterOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _B3MasterOption value)  $default,){
final _that = this;
switch (_that) {
case _B3MasterOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _B3MasterOption value)?  $default,){
final _that = this;
switch (_that) {
case _B3MasterOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'order_no')  int? orderNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _B3MasterOption() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.orderNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'order_no')  int? orderNo)  $default,) {final _that = this;
switch (_that) {
case _B3MasterOption():
return $default(_that.id,_that.name,_that.isActive,_that.orderNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'order_no')  int? orderNo)?  $default,) {final _that = this;
switch (_that) {
case _B3MasterOption() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.orderNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _B3MasterOption implements B3MasterOption {
  const _B3MasterOption({required this.id, required this.name, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'order_no') this.orderNo});
  factory _B3MasterOption.fromJson(Map<String, dynamic> json) => _$B3MasterOptionFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'order_no') final  int? orderNo;

/// Create a copy of B3MasterOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$B3MasterOptionCopyWith<_B3MasterOption> get copyWith => __$B3MasterOptionCopyWithImpl<_B3MasterOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$B3MasterOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _B3MasterOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,orderNo);

@override
String toString() {
  return 'B3MasterOption(id: $id, name: $name, isActive: $isActive, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class _$B3MasterOptionCopyWith<$Res> implements $B3MasterOptionCopyWith<$Res> {
  factory _$B3MasterOptionCopyWith(_B3MasterOption value, $Res Function(_B3MasterOption) _then) = __$B3MasterOptionCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'order_no') int? orderNo
});




}
/// @nodoc
class __$B3MasterOptionCopyWithImpl<$Res>
    implements _$B3MasterOptionCopyWith<$Res> {
  __$B3MasterOptionCopyWithImpl(this._self, this._then);

  final _B3MasterOption _self;
  final $Res Function(_B3MasterOption) _then;

/// Create a copy of B3MasterOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? orderNo = freezed,}) {
  return _then(_B3MasterOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
