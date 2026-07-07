// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_queue_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitQueueItem {

 String get id; String get endpoint; String get method; Map<String, dynamic> get payload; DateTime get createdAt; int get attempts; String get status; String? get lastError;
/// Create a copy of SubmitQueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitQueueItemCopyWith<SubmitQueueItem> get copyWith => _$SubmitQueueItemCopyWithImpl<SubmitQueueItem>(this as SubmitQueueItem, _$identity);

  /// Serializes this SubmitQueueItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,endpoint,method,const DeepCollectionEquality().hash(payload),createdAt,attempts,status,lastError);

@override
String toString() {
  return 'SubmitQueueItem(id: $id, endpoint: $endpoint, method: $method, payload: $payload, createdAt: $createdAt, attempts: $attempts, status: $status, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $SubmitQueueItemCopyWith<$Res>  {
  factory $SubmitQueueItemCopyWith(SubmitQueueItem value, $Res Function(SubmitQueueItem) _then) = _$SubmitQueueItemCopyWithImpl;
@useResult
$Res call({
 String id, String endpoint, String method, Map<String, dynamic> payload, DateTime createdAt, int attempts, String status, String? lastError
});




}
/// @nodoc
class _$SubmitQueueItemCopyWithImpl<$Res>
    implements $SubmitQueueItemCopyWith<$Res> {
  _$SubmitQueueItemCopyWithImpl(this._self, this._then);

  final SubmitQueueItem _self;
  final $Res Function(SubmitQueueItem) _then;

/// Create a copy of SubmitQueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? endpoint = null,Object? method = null,Object? payload = null,Object? createdAt = null,Object? attempts = null,Object? status = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitQueueItem].
extension SubmitQueueItemPatterns on SubmitQueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitQueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitQueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitQueueItem value)  $default,){
final _that = this;
switch (_that) {
case _SubmitQueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitQueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitQueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String endpoint,  String method,  Map<String, dynamic> payload,  DateTime createdAt,  int attempts,  String status,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitQueueItem() when $default != null:
return $default(_that.id,_that.endpoint,_that.method,_that.payload,_that.createdAt,_that.attempts,_that.status,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String endpoint,  String method,  Map<String, dynamic> payload,  DateTime createdAt,  int attempts,  String status,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _SubmitQueueItem():
return $default(_that.id,_that.endpoint,_that.method,_that.payload,_that.createdAt,_that.attempts,_that.status,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String endpoint,  String method,  Map<String, dynamic> payload,  DateTime createdAt,  int attempts,  String status,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _SubmitQueueItem() when $default != null:
return $default(_that.id,_that.endpoint,_that.method,_that.payload,_that.createdAt,_that.attempts,_that.status,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmitQueueItem implements SubmitQueueItem {
  const _SubmitQueueItem({required this.id, required this.endpoint, required this.method, required final  Map<String, dynamic> payload, required this.createdAt, this.attempts = 0, this.status = 'pending', this.lastError}): _payload = payload;
  factory _SubmitQueueItem.fromJson(Map<String, dynamic> json) => _$SubmitQueueItemFromJson(json);

@override final  String id;
@override final  String endpoint;
@override final  String method;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override final  DateTime createdAt;
@override@JsonKey() final  int attempts;
@override@JsonKey() final  String status;
@override final  String? lastError;

/// Create a copy of SubmitQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitQueueItemCopyWith<_SubmitQueueItem> get copyWith => __$SubmitQueueItemCopyWithImpl<_SubmitQueueItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitQueueItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitQueueItem&&(identical(other.id, id) || other.id == id)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,endpoint,method,const DeepCollectionEquality().hash(_payload),createdAt,attempts,status,lastError);

@override
String toString() {
  return 'SubmitQueueItem(id: $id, endpoint: $endpoint, method: $method, payload: $payload, createdAt: $createdAt, attempts: $attempts, status: $status, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$SubmitQueueItemCopyWith<$Res> implements $SubmitQueueItemCopyWith<$Res> {
  factory _$SubmitQueueItemCopyWith(_SubmitQueueItem value, $Res Function(_SubmitQueueItem) _then) = __$SubmitQueueItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String endpoint, String method, Map<String, dynamic> payload, DateTime createdAt, int attempts, String status, String? lastError
});




}
/// @nodoc
class __$SubmitQueueItemCopyWithImpl<$Res>
    implements _$SubmitQueueItemCopyWith<$Res> {
  __$SubmitQueueItemCopyWithImpl(this._self, this._then);

  final _SubmitQueueItem _self;
  final $Res Function(_SubmitQueueItem) _then;

/// Create a copy of SubmitQueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? endpoint = null,Object? method = null,Object? payload = null,Object? createdAt = null,Object? attempts = null,Object? status = null,Object? lastError = freezed,}) {
  return _then(_SubmitQueueItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
