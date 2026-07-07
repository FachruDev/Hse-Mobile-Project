// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'b3_master_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$B3MasterState {

 List<B3MasterOption> get wasteTypes; List<B3MasterOption> get departments;
/// Create a copy of B3MasterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$B3MasterStateCopyWith<B3MasterState> get copyWith => _$B3MasterStateCopyWithImpl<B3MasterState>(this as B3MasterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is B3MasterState&&const DeepCollectionEquality().equals(other.wasteTypes, wasteTypes)&&const DeepCollectionEquality().equals(other.departments, departments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(wasteTypes),const DeepCollectionEquality().hash(departments));

@override
String toString() {
  return 'B3MasterState(wasteTypes: $wasteTypes, departments: $departments)';
}


}

/// @nodoc
abstract mixin class $B3MasterStateCopyWith<$Res>  {
  factory $B3MasterStateCopyWith(B3MasterState value, $Res Function(B3MasterState) _then) = _$B3MasterStateCopyWithImpl;
@useResult
$Res call({
 List<B3MasterOption> wasteTypes, List<B3MasterOption> departments
});




}
/// @nodoc
class _$B3MasterStateCopyWithImpl<$Res>
    implements $B3MasterStateCopyWith<$Res> {
  _$B3MasterStateCopyWithImpl(this._self, this._then);

  final B3MasterState _self;
  final $Res Function(B3MasterState) _then;

/// Create a copy of B3MasterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wasteTypes = null,Object? departments = null,}) {
  return _then(_self.copyWith(
wasteTypes: null == wasteTypes ? _self.wasteTypes : wasteTypes // ignore: cast_nullable_to_non_nullable
as List<B3MasterOption>,departments: null == departments ? _self.departments : departments // ignore: cast_nullable_to_non_nullable
as List<B3MasterOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [B3MasterState].
extension B3MasterStatePatterns on B3MasterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _B3MasterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _B3MasterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _B3MasterState value)  $default,){
final _that = this;
switch (_that) {
case _B3MasterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _B3MasterState value)?  $default,){
final _that = this;
switch (_that) {
case _B3MasterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<B3MasterOption> wasteTypes,  List<B3MasterOption> departments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _B3MasterState() when $default != null:
return $default(_that.wasteTypes,_that.departments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<B3MasterOption> wasteTypes,  List<B3MasterOption> departments)  $default,) {final _that = this;
switch (_that) {
case _B3MasterState():
return $default(_that.wasteTypes,_that.departments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<B3MasterOption> wasteTypes,  List<B3MasterOption> departments)?  $default,) {final _that = this;
switch (_that) {
case _B3MasterState() when $default != null:
return $default(_that.wasteTypes,_that.departments);case _:
  return null;

}
}

}

/// @nodoc


class _B3MasterState implements B3MasterState {
  const _B3MasterState({final  List<B3MasterOption> wasteTypes = const <B3MasterOption>[], final  List<B3MasterOption> departments = const <B3MasterOption>[]}): _wasteTypes = wasteTypes,_departments = departments;
  

 final  List<B3MasterOption> _wasteTypes;
@override@JsonKey() List<B3MasterOption> get wasteTypes {
  if (_wasteTypes is EqualUnmodifiableListView) return _wasteTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wasteTypes);
}

 final  List<B3MasterOption> _departments;
@override@JsonKey() List<B3MasterOption> get departments {
  if (_departments is EqualUnmodifiableListView) return _departments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_departments);
}


/// Create a copy of B3MasterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$B3MasterStateCopyWith<_B3MasterState> get copyWith => __$B3MasterStateCopyWithImpl<_B3MasterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _B3MasterState&&const DeepCollectionEquality().equals(other._wasteTypes, _wasteTypes)&&const DeepCollectionEquality().equals(other._departments, _departments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_wasteTypes),const DeepCollectionEquality().hash(_departments));

@override
String toString() {
  return 'B3MasterState(wasteTypes: $wasteTypes, departments: $departments)';
}


}

/// @nodoc
abstract mixin class _$B3MasterStateCopyWith<$Res> implements $B3MasterStateCopyWith<$Res> {
  factory _$B3MasterStateCopyWith(_B3MasterState value, $Res Function(_B3MasterState) _then) = __$B3MasterStateCopyWithImpl;
@override @useResult
$Res call({
 List<B3MasterOption> wasteTypes, List<B3MasterOption> departments
});




}
/// @nodoc
class __$B3MasterStateCopyWithImpl<$Res>
    implements _$B3MasterStateCopyWith<$Res> {
  __$B3MasterStateCopyWithImpl(this._self, this._then);

  final _B3MasterState _self;
  final $Res Function(_B3MasterState) _then;

/// Create a copy of B3MasterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wasteTypes = null,Object? departments = null,}) {
  return _then(_B3MasterState(
wasteTypes: null == wasteTypes ? _self._wasteTypes : wasteTypes // ignore: cast_nullable_to_non_nullable
as List<B3MasterOption>,departments: null == departments ? _self._departments : departments // ignore: cast_nullable_to_non_nullable
as List<B3MasterOption>,
  ));
}


}

// dart format on
