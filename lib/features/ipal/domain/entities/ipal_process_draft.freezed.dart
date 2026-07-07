// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ipal_process_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IpalProcessDraft {

 String get tanggal; int get templateId; Map<String, String> get processValues; Map<String, String> get processNotes; Map<String, String> get processAttachmentPaths; List<IpalBatchDraft> get batches;
/// Create a copy of IpalProcessDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalProcessDraftCopyWith<IpalProcessDraft> get copyWith => _$IpalProcessDraftCopyWithImpl<IpalProcessDraft>(this as IpalProcessDraft, _$identity);

  /// Serializes this IpalProcessDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalProcessDraft&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other.processValues, processValues)&&const DeepCollectionEquality().equals(other.processNotes, processNotes)&&const DeepCollectionEquality().equals(other.processAttachmentPaths, processAttachmentPaths)&&const DeepCollectionEquality().equals(other.batches, batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,templateId,const DeepCollectionEquality().hash(processValues),const DeepCollectionEquality().hash(processNotes),const DeepCollectionEquality().hash(processAttachmentPaths),const DeepCollectionEquality().hash(batches));

@override
String toString() {
  return 'IpalProcessDraft(tanggal: $tanggal, templateId: $templateId, processValues: $processValues, processNotes: $processNotes, processAttachmentPaths: $processAttachmentPaths, batches: $batches)';
}


}

/// @nodoc
abstract mixin class $IpalProcessDraftCopyWith<$Res>  {
  factory $IpalProcessDraftCopyWith(IpalProcessDraft value, $Res Function(IpalProcessDraft) _then) = _$IpalProcessDraftCopyWithImpl;
@useResult
$Res call({
 String tanggal, int templateId, Map<String, String> processValues, Map<String, String> processNotes, Map<String, String> processAttachmentPaths, List<IpalBatchDraft> batches
});




}
/// @nodoc
class _$IpalProcessDraftCopyWithImpl<$Res>
    implements $IpalProcessDraftCopyWith<$Res> {
  _$IpalProcessDraftCopyWithImpl(this._self, this._then);

  final IpalProcessDraft _self;
  final $Res Function(IpalProcessDraft) _then;

/// Create a copy of IpalProcessDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tanggal = null,Object? templateId = null,Object? processValues = null,Object? processNotes = null,Object? processAttachmentPaths = null,Object? batches = null,}) {
  return _then(_self.copyWith(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,processValues: null == processValues ? _self.processValues : processValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,processNotes: null == processNotes ? _self.processNotes : processNotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,processAttachmentPaths: null == processAttachmentPaths ? _self.processAttachmentPaths : processAttachmentPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<IpalBatchDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalProcessDraft].
extension IpalProcessDraftPatterns on IpalProcessDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalProcessDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalProcessDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalProcessDraft value)  $default,){
final _that = this;
switch (_that) {
case _IpalProcessDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalProcessDraft value)?  $default,){
final _that = this;
switch (_that) {
case _IpalProcessDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tanggal,  int templateId,  Map<String, String> processValues,  Map<String, String> processNotes,  Map<String, String> processAttachmentPaths,  List<IpalBatchDraft> batches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalProcessDraft() when $default != null:
return $default(_that.tanggal,_that.templateId,_that.processValues,_that.processNotes,_that.processAttachmentPaths,_that.batches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tanggal,  int templateId,  Map<String, String> processValues,  Map<String, String> processNotes,  Map<String, String> processAttachmentPaths,  List<IpalBatchDraft> batches)  $default,) {final _that = this;
switch (_that) {
case _IpalProcessDraft():
return $default(_that.tanggal,_that.templateId,_that.processValues,_that.processNotes,_that.processAttachmentPaths,_that.batches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tanggal,  int templateId,  Map<String, String> processValues,  Map<String, String> processNotes,  Map<String, String> processAttachmentPaths,  List<IpalBatchDraft> batches)?  $default,) {final _that = this;
switch (_that) {
case _IpalProcessDraft() when $default != null:
return $default(_that.tanggal,_that.templateId,_that.processValues,_that.processNotes,_that.processAttachmentPaths,_that.batches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalProcessDraft implements IpalProcessDraft {
  const _IpalProcessDraft({required this.tanggal, required this.templateId, final  Map<String, String> processValues = const <String, String>{}, final  Map<String, String> processNotes = const <String, String>{}, final  Map<String, String> processAttachmentPaths = const <String, String>{}, final  List<IpalBatchDraft> batches = const <IpalBatchDraft>[]}): _processValues = processValues,_processNotes = processNotes,_processAttachmentPaths = processAttachmentPaths,_batches = batches;
  factory _IpalProcessDraft.fromJson(Map<String, dynamic> json) => _$IpalProcessDraftFromJson(json);

@override final  String tanggal;
@override final  int templateId;
 final  Map<String, String> _processValues;
@override@JsonKey() Map<String, String> get processValues {
  if (_processValues is EqualUnmodifiableMapView) return _processValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_processValues);
}

 final  Map<String, String> _processNotes;
@override@JsonKey() Map<String, String> get processNotes {
  if (_processNotes is EqualUnmodifiableMapView) return _processNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_processNotes);
}

 final  Map<String, String> _processAttachmentPaths;
@override@JsonKey() Map<String, String> get processAttachmentPaths {
  if (_processAttachmentPaths is EqualUnmodifiableMapView) return _processAttachmentPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_processAttachmentPaths);
}

 final  List<IpalBatchDraft> _batches;
@override@JsonKey() List<IpalBatchDraft> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}


/// Create a copy of IpalProcessDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalProcessDraftCopyWith<_IpalProcessDraft> get copyWith => __$IpalProcessDraftCopyWithImpl<_IpalProcessDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalProcessDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalProcessDraft&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other._processValues, _processValues)&&const DeepCollectionEquality().equals(other._processNotes, _processNotes)&&const DeepCollectionEquality().equals(other._processAttachmentPaths, _processAttachmentPaths)&&const DeepCollectionEquality().equals(other._batches, _batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tanggal,templateId,const DeepCollectionEquality().hash(_processValues),const DeepCollectionEquality().hash(_processNotes),const DeepCollectionEquality().hash(_processAttachmentPaths),const DeepCollectionEquality().hash(_batches));

@override
String toString() {
  return 'IpalProcessDraft(tanggal: $tanggal, templateId: $templateId, processValues: $processValues, processNotes: $processNotes, processAttachmentPaths: $processAttachmentPaths, batches: $batches)';
}


}

/// @nodoc
abstract mixin class _$IpalProcessDraftCopyWith<$Res> implements $IpalProcessDraftCopyWith<$Res> {
  factory _$IpalProcessDraftCopyWith(_IpalProcessDraft value, $Res Function(_IpalProcessDraft) _then) = __$IpalProcessDraftCopyWithImpl;
@override @useResult
$Res call({
 String tanggal, int templateId, Map<String, String> processValues, Map<String, String> processNotes, Map<String, String> processAttachmentPaths, List<IpalBatchDraft> batches
});




}
/// @nodoc
class __$IpalProcessDraftCopyWithImpl<$Res>
    implements _$IpalProcessDraftCopyWith<$Res> {
  __$IpalProcessDraftCopyWithImpl(this._self, this._then);

  final _IpalProcessDraft _self;
  final $Res Function(_IpalProcessDraft) _then;

/// Create a copy of IpalProcessDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tanggal = null,Object? templateId = null,Object? processValues = null,Object? processNotes = null,Object? processAttachmentPaths = null,Object? batches = null,}) {
  return _then(_IpalProcessDraft(
tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int,processValues: null == processValues ? _self._processValues : processValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,processNotes: null == processNotes ? _self._processNotes : processNotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,processAttachmentPaths: null == processAttachmentPaths ? _self._processAttachmentPaths : processAttachmentPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<IpalBatchDraft>,
  ));
}


}


/// @nodoc
mixin _$IpalBatchDraft {

 int get batchNo; Map<String, String> get values; Map<String, String> get notes;
/// Create a copy of IpalBatchDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalBatchDraftCopyWith<IpalBatchDraft> get copyWith => _$IpalBatchDraftCopyWithImpl<IpalBatchDraft>(this as IpalBatchDraft, _$identity);

  /// Serializes this IpalBatchDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalBatchDraft&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&const DeepCollectionEquality().equals(other.values, values)&&const DeepCollectionEquality().equals(other.notes, notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchNo,const DeepCollectionEquality().hash(values),const DeepCollectionEquality().hash(notes));

@override
String toString() {
  return 'IpalBatchDraft(batchNo: $batchNo, values: $values, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $IpalBatchDraftCopyWith<$Res>  {
  factory $IpalBatchDraftCopyWith(IpalBatchDraft value, $Res Function(IpalBatchDraft) _then) = _$IpalBatchDraftCopyWithImpl;
@useResult
$Res call({
 int batchNo, Map<String, String> values, Map<String, String> notes
});




}
/// @nodoc
class _$IpalBatchDraftCopyWithImpl<$Res>
    implements $IpalBatchDraftCopyWith<$Res> {
  _$IpalBatchDraftCopyWithImpl(this._self, this._then);

  final IpalBatchDraft _self;
  final $Res Function(IpalBatchDraft) _then;

/// Create a copy of IpalBatchDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? batchNo = null,Object? values = null,Object? notes = null,}) {
  return _then(_self.copyWith(
batchNo: null == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as int,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalBatchDraft].
extension IpalBatchDraftPatterns on IpalBatchDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalBatchDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalBatchDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalBatchDraft value)  $default,){
final _that = this;
switch (_that) {
case _IpalBatchDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalBatchDraft value)?  $default,){
final _that = this;
switch (_that) {
case _IpalBatchDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int batchNo,  Map<String, String> values,  Map<String, String> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalBatchDraft() when $default != null:
return $default(_that.batchNo,_that.values,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int batchNo,  Map<String, String> values,  Map<String, String> notes)  $default,) {final _that = this;
switch (_that) {
case _IpalBatchDraft():
return $default(_that.batchNo,_that.values,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int batchNo,  Map<String, String> values,  Map<String, String> notes)?  $default,) {final _that = this;
switch (_that) {
case _IpalBatchDraft() when $default != null:
return $default(_that.batchNo,_that.values,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalBatchDraft implements IpalBatchDraft {
  const _IpalBatchDraft({required this.batchNo, final  Map<String, String> values = const <String, String>{}, final  Map<String, String> notes = const <String, String>{}}): _values = values,_notes = notes;
  factory _IpalBatchDraft.fromJson(Map<String, dynamic> json) => _$IpalBatchDraftFromJson(json);

@override final  int batchNo;
 final  Map<String, String> _values;
@override@JsonKey() Map<String, String> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}

 final  Map<String, String> _notes;
@override@JsonKey() Map<String, String> get notes {
  if (_notes is EqualUnmodifiableMapView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_notes);
}


/// Create a copy of IpalBatchDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalBatchDraftCopyWith<_IpalBatchDraft> get copyWith => __$IpalBatchDraftCopyWithImpl<_IpalBatchDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalBatchDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalBatchDraft&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&const DeepCollectionEquality().equals(other._values, _values)&&const DeepCollectionEquality().equals(other._notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchNo,const DeepCollectionEquality().hash(_values),const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'IpalBatchDraft(batchNo: $batchNo, values: $values, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$IpalBatchDraftCopyWith<$Res> implements $IpalBatchDraftCopyWith<$Res> {
  factory _$IpalBatchDraftCopyWith(_IpalBatchDraft value, $Res Function(_IpalBatchDraft) _then) = __$IpalBatchDraftCopyWithImpl;
@override @useResult
$Res call({
 int batchNo, Map<String, String> values, Map<String, String> notes
});




}
/// @nodoc
class __$IpalBatchDraftCopyWithImpl<$Res>
    implements _$IpalBatchDraftCopyWith<$Res> {
  __$IpalBatchDraftCopyWithImpl(this._self, this._then);

  final _IpalBatchDraft _self;
  final $Res Function(_IpalBatchDraft) _then;

/// Create a copy of IpalBatchDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? batchNo = null,Object? values = null,Object? notes = null,}) {
  return _then(_IpalBatchDraft(
batchNo: null == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as int,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, String>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
