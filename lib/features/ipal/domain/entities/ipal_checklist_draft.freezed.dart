// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ipal_checklist_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IpalChecklistDraft {

 String get tanggal; int get templateId; Map<String, String> get statuses; Map<String, String> get notes; Map<String, String> get attachmentPaths;
/// Create a copy of IpalChecklistDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalChecklistDraftCopyWith<IpalChecklistDraft> get copyWith => _$IpalChecklistDraftCopyWithImpl<IpalChecklistDraft>(this as IpalChecklistDraft, _$identity);

  /// Serializes this IpalChecklistDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalChecklistDraft&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.attachmentPaths, attachmentPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,templateId,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(attachmentPaths));

@override
String toString() {
  return 'IpalChecklistDraft(tanggal: $tanggal, templateId: $templateId, statuses: $statuses, notes: $notes, attachmentPaths: $attachmentPaths)';
}


}

/// @nodoc
abstract mixin class $IpalChecklistDraftCopyWith<$Res>  {
  factory $IpalChecklistDraftCopyWith(IpalChecklistDraft value, $Res Function(IpalChecklistDraft) _then) = _$IpalChecklistDraftCopyWithImpl;
@useResult
$Res call({
 String tanggal, int templateId, Map<String, String> statuses, Map<String, String> notes, Map<String, String> attachmentPaths
});




}
/// @nodoc
class _$IpalChecklistDraftCopyWithImpl<$Res>
    implements $IpalChecklistDraftCopyWith<$Res> {
  _$IpalChecklistDraftCopyWithImpl(this._self, this._then);

  final IpalChecklistDraft _self;
  final $Res Function(IpalChecklistDraft) _then;

/// Create a copy of IpalChecklistDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tanggal = null,Object? templateId = null,Object? statuses = null,Object? notes = null,Object? attachmentPaths = null,}) {
  return _then(_self.copyWith(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,attachmentPaths: null == attachmentPaths ? _self.attachmentPaths : attachmentPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalChecklistDraft].
extension IpalChecklistDraftPatterns on IpalChecklistDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalChecklistDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalChecklistDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalChecklistDraft value)  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalChecklistDraft value)?  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tanggal,  int templateId,  Map<String, String> statuses,  Map<String, String> notes,  Map<String, String> attachmentPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalChecklistDraft() when $default != null:
return $default(_that.tanggal,_that.templateId,_that.statuses,_that.notes,_that.attachmentPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tanggal,  int templateId,  Map<String, String> statuses,  Map<String, String> notes,  Map<String, String> attachmentPaths)  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistDraft():
return $default(_that.tanggal,_that.templateId,_that.statuses,_that.notes,_that.attachmentPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tanggal,  int templateId,  Map<String, String> statuses,  Map<String, String> notes,  Map<String, String> attachmentPaths)?  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistDraft() when $default != null:
return $default(_that.tanggal,_that.templateId,_that.statuses,_that.notes,_that.attachmentPaths);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalChecklistDraft implements IpalChecklistDraft {
  const _IpalChecklistDraft({required this.tanggal, required this.templateId, final  Map<String, String> statuses = const <String, String>{}, final  Map<String, String> notes = const <String, String>{}, final  Map<String, String> attachmentPaths = const <String, String>{}}): _statuses = statuses,_notes = notes,_attachmentPaths = attachmentPaths;
  factory _IpalChecklistDraft.fromJson(Map<String, dynamic> json) => _$IpalChecklistDraftFromJson(json);

@override final  String tanggal;
@override final  int templateId;
 final  Map<String, String> _statuses;
@override@JsonKey() Map<String, String> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

 final  Map<String, String> _notes;
@override@JsonKey() Map<String, String> get notes {
  if (_notes is EqualUnmodifiableMapView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_notes);
}

 final  Map<String, String> _attachmentPaths;
@override@JsonKey() Map<String, String> get attachmentPaths {
  if (_attachmentPaths is EqualUnmodifiableMapView) return _attachmentPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attachmentPaths);
}


/// Create a copy of IpalChecklistDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalChecklistDraftCopyWith<_IpalChecklistDraft> get copyWith => __$IpalChecklistDraftCopyWithImpl<_IpalChecklistDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalChecklistDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalChecklistDraft&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._attachmentPaths, _attachmentPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,templateId,const DeepCollectionEquality().hash(_statuses),const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_attachmentPaths));

@override
String toString() {
  return 'IpalChecklistDraft(tanggal: $tanggal, templateId: $templateId, statuses: $statuses, notes: $notes, attachmentPaths: $attachmentPaths)';
}


}

/// @nodoc
abstract mixin class _$IpalChecklistDraftCopyWith<$Res> implements $IpalChecklistDraftCopyWith<$Res> {
  factory _$IpalChecklistDraftCopyWith(_IpalChecklistDraft value, $Res Function(_IpalChecklistDraft) _then) = __$IpalChecklistDraftCopyWithImpl;
@override @useResult
$Res call({
 String tanggal, int templateId, Map<String, String> statuses, Map<String, String> notes, Map<String, String> attachmentPaths
});




}
/// @nodoc
class __$IpalChecklistDraftCopyWithImpl<$Res>
    implements _$IpalChecklistDraftCopyWith<$Res> {
  __$IpalChecklistDraftCopyWithImpl(this._self, this._then);

  final _IpalChecklistDraft _self;
  final $Res Function(_IpalChecklistDraft) _then;

/// Create a copy of IpalChecklistDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tanggal = null,Object? templateId = null,Object? statuses = null,Object? notes = null,Object? attachmentPaths = null,}) {
  return _then(_IpalChecklistDraft(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as Map<String, String>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,attachmentPaths: null == attachmentPaths ? _self._attachmentPaths : attachmentPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
