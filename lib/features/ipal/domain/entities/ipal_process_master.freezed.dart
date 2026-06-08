// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ipal_process_master.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IpalProcessMaster {

 List<IpalProcessTemplate> get templates;@JsonKey(name: 'batch_items') List<IpalProcessItem> get batchItems;
/// Create a copy of IpalProcessMaster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalProcessMasterCopyWith<IpalProcessMaster> get copyWith => _$IpalProcessMasterCopyWithImpl<IpalProcessMaster>(this as IpalProcessMaster, _$identity);

  /// Serializes this IpalProcessMaster to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalProcessMaster&&const DeepCollectionEquality().equals(other.templates, templates)&&const DeepCollectionEquality().equals(other.batchItems, batchItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(templates),const DeepCollectionEquality().hash(batchItems));

@override
String toString() {
  return 'IpalProcessMaster(templates: $templates, batchItems: $batchItems)';
}


}

/// @nodoc
abstract mixin class $IpalProcessMasterCopyWith<$Res>  {
  factory $IpalProcessMasterCopyWith(IpalProcessMaster value, $Res Function(IpalProcessMaster) _then) = _$IpalProcessMasterCopyWithImpl;
@useResult
$Res call({
 List<IpalProcessTemplate> templates,@JsonKey(name: 'batch_items') List<IpalProcessItem> batchItems
});




}
/// @nodoc
class _$IpalProcessMasterCopyWithImpl<$Res>
    implements $IpalProcessMasterCopyWith<$Res> {
  _$IpalProcessMasterCopyWithImpl(this._self, this._then);

  final IpalProcessMaster _self;
  final $Res Function(IpalProcessMaster) _then;

/// Create a copy of IpalProcessMaster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templates = null,Object? batchItems = null,}) {
  return _then(_self.copyWith(
templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<IpalProcessTemplate>,batchItems: null == batchItems ? _self.batchItems : batchItems // ignore: cast_nullable_to_non_nullable
as List<IpalProcessItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalProcessMaster].
extension IpalProcessMasterPatterns on IpalProcessMaster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalProcessMaster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalProcessMaster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalProcessMaster value)  $default,){
final _that = this;
switch (_that) {
case _IpalProcessMaster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalProcessMaster value)?  $default,){
final _that = this;
switch (_that) {
case _IpalProcessMaster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<IpalProcessTemplate> templates, @JsonKey(name: 'batch_items')  List<IpalProcessItem> batchItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalProcessMaster() when $default != null:
return $default(_that.templates,_that.batchItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<IpalProcessTemplate> templates, @JsonKey(name: 'batch_items')  List<IpalProcessItem> batchItems)  $default,) {final _that = this;
switch (_that) {
case _IpalProcessMaster():
return $default(_that.templates,_that.batchItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<IpalProcessTemplate> templates, @JsonKey(name: 'batch_items')  List<IpalProcessItem> batchItems)?  $default,) {final _that = this;
switch (_that) {
case _IpalProcessMaster() when $default != null:
return $default(_that.templates,_that.batchItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalProcessMaster implements IpalProcessMaster {
  const _IpalProcessMaster({final  List<IpalProcessTemplate> templates = const <IpalProcessTemplate>[], @JsonKey(name: 'batch_items') final  List<IpalProcessItem> batchItems = const <IpalProcessItem>[]}): _templates = templates,_batchItems = batchItems;
  factory _IpalProcessMaster.fromJson(Map<String, dynamic> json) => _$IpalProcessMasterFromJson(json);

 final  List<IpalProcessTemplate> _templates;
@override@JsonKey() List<IpalProcessTemplate> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}

 final  List<IpalProcessItem> _batchItems;
@override@JsonKey(name: 'batch_items') List<IpalProcessItem> get batchItems {
  if (_batchItems is EqualUnmodifiableListView) return _batchItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batchItems);
}


/// Create a copy of IpalProcessMaster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalProcessMasterCopyWith<_IpalProcessMaster> get copyWith => __$IpalProcessMasterCopyWithImpl<_IpalProcessMaster>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalProcessMasterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalProcessMaster&&const DeepCollectionEquality().equals(other._templates, _templates)&&const DeepCollectionEquality().equals(other._batchItems, _batchItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_templates),const DeepCollectionEquality().hash(_batchItems));

@override
String toString() {
  return 'IpalProcessMaster(templates: $templates, batchItems: $batchItems)';
}


}

/// @nodoc
abstract mixin class _$IpalProcessMasterCopyWith<$Res> implements $IpalProcessMasterCopyWith<$Res> {
  factory _$IpalProcessMasterCopyWith(_IpalProcessMaster value, $Res Function(_IpalProcessMaster) _then) = __$IpalProcessMasterCopyWithImpl;
@override @useResult
$Res call({
 List<IpalProcessTemplate> templates,@JsonKey(name: 'batch_items') List<IpalProcessItem> batchItems
});




}
/// @nodoc
class __$IpalProcessMasterCopyWithImpl<$Res>
    implements _$IpalProcessMasterCopyWith<$Res> {
  __$IpalProcessMasterCopyWithImpl(this._self, this._then);

  final _IpalProcessMaster _self;
  final $Res Function(_IpalProcessMaster) _then;

/// Create a copy of IpalProcessMaster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templates = null,Object? batchItems = null,}) {
  return _then(_IpalProcessMaster(
templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<IpalProcessTemplate>,batchItems: null == batchItems ? _self._batchItems : batchItems // ignore: cast_nullable_to_non_nullable
as List<IpalProcessItem>,
  ));
}


}


/// @nodoc
mixin _$IpalProcessTemplate {

 int get id; String get name; List<IpalProcessSection> get sections;
/// Create a copy of IpalProcessTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalProcessTemplateCopyWith<IpalProcessTemplate> get copyWith => _$IpalProcessTemplateCopyWithImpl<IpalProcessTemplate>(this as IpalProcessTemplate, _$identity);

  /// Serializes this IpalProcessTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalProcessTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.sections, sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'IpalProcessTemplate(id: $id, name: $name, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $IpalProcessTemplateCopyWith<$Res>  {
  factory $IpalProcessTemplateCopyWith(IpalProcessTemplate value, $Res Function(IpalProcessTemplate) _then) = _$IpalProcessTemplateCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<IpalProcessSection> sections
});




}
/// @nodoc
class _$IpalProcessTemplateCopyWithImpl<$Res>
    implements $IpalProcessTemplateCopyWith<$Res> {
  _$IpalProcessTemplateCopyWithImpl(this._self, this._then);

  final IpalProcessTemplate _self;
  final $Res Function(IpalProcessTemplate) _then;

/// Create a copy of IpalProcessTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sections = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<IpalProcessSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalProcessTemplate].
extension IpalProcessTemplatePatterns on IpalProcessTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalProcessTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalProcessTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalProcessTemplate value)  $default,){
final _that = this;
switch (_that) {
case _IpalProcessTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalProcessTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _IpalProcessTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<IpalProcessSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalProcessTemplate() when $default != null:
return $default(_that.id,_that.name,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<IpalProcessSection> sections)  $default,) {final _that = this;
switch (_that) {
case _IpalProcessTemplate():
return $default(_that.id,_that.name,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<IpalProcessSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _IpalProcessTemplate() when $default != null:
return $default(_that.id,_that.name,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalProcessTemplate implements IpalProcessTemplate {
  const _IpalProcessTemplate({required this.id, required this.name, final  List<IpalProcessSection> sections = const <IpalProcessSection>[]}): _sections = sections;
  factory _IpalProcessTemplate.fromJson(Map<String, dynamic> json) => _$IpalProcessTemplateFromJson(json);

@override final  int id;
@override final  String name;
 final  List<IpalProcessSection> _sections;
@override@JsonKey() List<IpalProcessSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of IpalProcessTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalProcessTemplateCopyWith<_IpalProcessTemplate> get copyWith => __$IpalProcessTemplateCopyWithImpl<_IpalProcessTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalProcessTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalProcessTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'IpalProcessTemplate(id: $id, name: $name, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$IpalProcessTemplateCopyWith<$Res> implements $IpalProcessTemplateCopyWith<$Res> {
  factory _$IpalProcessTemplateCopyWith(_IpalProcessTemplate value, $Res Function(_IpalProcessTemplate) _then) = __$IpalProcessTemplateCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<IpalProcessSection> sections
});




}
/// @nodoc
class __$IpalProcessTemplateCopyWithImpl<$Res>
    implements _$IpalProcessTemplateCopyWith<$Res> {
  __$IpalProcessTemplateCopyWithImpl(this._self, this._then);

  final _IpalProcessTemplate _self;
  final $Res Function(_IpalProcessTemplate) _then;

/// Create a copy of IpalProcessTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sections = null,}) {
  return _then(_IpalProcessTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<IpalProcessSection>,
  ));
}


}


/// @nodoc
mixin _$IpalProcessSection {

 int get id; String get name; List<IpalProcessItem> get items;
/// Create a copy of IpalProcessSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalProcessSectionCopyWith<IpalProcessSection> get copyWith => _$IpalProcessSectionCopyWithImpl<IpalProcessSection>(this as IpalProcessSection, _$identity);

  /// Serializes this IpalProcessSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalProcessSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'IpalProcessSection(id: $id, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $IpalProcessSectionCopyWith<$Res>  {
  factory $IpalProcessSectionCopyWith(IpalProcessSection value, $Res Function(IpalProcessSection) _then) = _$IpalProcessSectionCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<IpalProcessItem> items
});




}
/// @nodoc
class _$IpalProcessSectionCopyWithImpl<$Res>
    implements $IpalProcessSectionCopyWith<$Res> {
  _$IpalProcessSectionCopyWithImpl(this._self, this._then);

  final IpalProcessSection _self;
  final $Res Function(IpalProcessSection) _then;

/// Create a copy of IpalProcessSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<IpalProcessItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalProcessSection].
extension IpalProcessSectionPatterns on IpalProcessSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalProcessSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalProcessSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalProcessSection value)  $default,){
final _that = this;
switch (_that) {
case _IpalProcessSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalProcessSection value)?  $default,){
final _that = this;
switch (_that) {
case _IpalProcessSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<IpalProcessItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalProcessSection() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<IpalProcessItem> items)  $default,) {final _that = this;
switch (_that) {
case _IpalProcessSection():
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<IpalProcessItem> items)?  $default,) {final _that = this;
switch (_that) {
case _IpalProcessSection() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalProcessSection implements IpalProcessSection {
  const _IpalProcessSection({required this.id, required this.name, final  List<IpalProcessItem> items = const <IpalProcessItem>[]}): _items = items;
  factory _IpalProcessSection.fromJson(Map<String, dynamic> json) => _$IpalProcessSectionFromJson(json);

@override final  int id;
@override final  String name;
 final  List<IpalProcessItem> _items;
@override@JsonKey() List<IpalProcessItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of IpalProcessSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalProcessSectionCopyWith<_IpalProcessSection> get copyWith => __$IpalProcessSectionCopyWithImpl<_IpalProcessSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalProcessSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalProcessSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'IpalProcessSection(id: $id, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$IpalProcessSectionCopyWith<$Res> implements $IpalProcessSectionCopyWith<$Res> {
  factory _$IpalProcessSectionCopyWith(_IpalProcessSection value, $Res Function(_IpalProcessSection) _then) = __$IpalProcessSectionCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<IpalProcessItem> items
});




}
/// @nodoc
class __$IpalProcessSectionCopyWithImpl<$Res>
    implements _$IpalProcessSectionCopyWith<$Res> {
  __$IpalProcessSectionCopyWithImpl(this._self, this._then);

  final _IpalProcessSection _self;
  final $Res Function(_IpalProcessSection) _then;

/// Create a copy of IpalProcessSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(_IpalProcessSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<IpalProcessItem>,
  ));
}


}


/// @nodoc
mixin _$IpalProcessItem {

 int get id; String get label;@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType get inputType; String? get standard;@JsonKey(name: 'order_no') int? get orderNo;
/// Create a copy of IpalProcessItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalProcessItemCopyWith<IpalProcessItem> get copyWith => _$IpalProcessItemCopyWithImpl<IpalProcessItem>(this as IpalProcessItem, _$identity);

  /// Serializes this IpalProcessItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalProcessItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,inputType,standard,orderNo);

@override
String toString() {
  return 'IpalProcessItem(id: $id, label: $label, inputType: $inputType, standard: $standard, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class $IpalProcessItemCopyWith<$Res>  {
  factory $IpalProcessItemCopyWith(IpalProcessItem value, $Res Function(IpalProcessItem) _then) = _$IpalProcessItemCopyWithImpl;
@useResult
$Res call({
 int id, String label,@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType inputType, String? standard,@JsonKey(name: 'order_no') int? orderNo
});




}
/// @nodoc
class _$IpalProcessItemCopyWithImpl<$Res>
    implements $IpalProcessItemCopyWith<$Res> {
  _$IpalProcessItemCopyWithImpl(this._self, this._then);

  final IpalProcessItem _self;
  final $Res Function(IpalProcessItem) _then;

/// Create a copy of IpalProcessItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? inputType = null,Object? standard = freezed,Object? orderNo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as HseInputType,standard: freezed == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String?,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalProcessItem].
extension IpalProcessItemPatterns on IpalProcessItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalProcessItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalProcessItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalProcessItem value)  $default,){
final _that = this;
switch (_that) {
case _IpalProcessItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalProcessItem value)?  $default,){
final _that = this;
switch (_that) {
case _IpalProcessItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'order_no')  int? orderNo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalProcessItem() when $default != null:
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.orderNo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'order_no')  int? orderNo)  $default,) {final _that = this;
switch (_that) {
case _IpalProcessItem():
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.orderNo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'order_no')  int? orderNo)?  $default,) {final _that = this;
switch (_that) {
case _IpalProcessItem() when $default != null:
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.orderNo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalProcessItem implements IpalProcessItem {
  const _IpalProcessItem({required this.id, required this.label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) required this.inputType, this.standard, @JsonKey(name: 'order_no') this.orderNo});
  factory _IpalProcessItem.fromJson(Map<String, dynamic> json) => _$IpalProcessItemFromJson(json);

@override final  int id;
@override final  String label;
@override@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) final  HseInputType inputType;
@override final  String? standard;
@override@JsonKey(name: 'order_no') final  int? orderNo;

/// Create a copy of IpalProcessItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalProcessItemCopyWith<_IpalProcessItem> get copyWith => __$IpalProcessItemCopyWithImpl<_IpalProcessItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalProcessItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalProcessItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,inputType,standard,orderNo);

@override
String toString() {
  return 'IpalProcessItem(id: $id, label: $label, inputType: $inputType, standard: $standard, orderNo: $orderNo)';
}


}

/// @nodoc
abstract mixin class _$IpalProcessItemCopyWith<$Res> implements $IpalProcessItemCopyWith<$Res> {
  factory _$IpalProcessItemCopyWith(_IpalProcessItem value, $Res Function(_IpalProcessItem) _then) = __$IpalProcessItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String label,@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType inputType, String? standard,@JsonKey(name: 'order_no') int? orderNo
});




}
/// @nodoc
class __$IpalProcessItemCopyWithImpl<$Res>
    implements _$IpalProcessItemCopyWith<$Res> {
  __$IpalProcessItemCopyWithImpl(this._self, this._then);

  final _IpalProcessItem _self;
  final $Res Function(_IpalProcessItem) _then;

/// Create a copy of IpalProcessItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? inputType = null,Object? standard = freezed,Object? orderNo = freezed,}) {
  return _then(_IpalProcessItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as HseInputType,standard: freezed == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String?,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
