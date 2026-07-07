// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ipal_checklist_master.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IpalChecklistTemplate {

 int get id; String get name;@JsonKey(name: 'is_active') bool get isActive; List<IpalChecklistItem> get items;
/// Create a copy of IpalChecklistTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalChecklistTemplateCopyWith<IpalChecklistTemplate> get copyWith => _$IpalChecklistTemplateCopyWithImpl<IpalChecklistTemplate>(this as IpalChecklistTemplate, _$identity);

  /// Serializes this IpalChecklistTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalChecklistTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'IpalChecklistTemplate(id: $id, name: $name, isActive: $isActive, items: $items)';
}


}

/// @nodoc
abstract mixin class $IpalChecklistTemplateCopyWith<$Res>  {
  factory $IpalChecklistTemplateCopyWith(IpalChecklistTemplate value, $Res Function(IpalChecklistTemplate) _then) = _$IpalChecklistTemplateCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive, List<IpalChecklistItem> items
});




}
/// @nodoc
class _$IpalChecklistTemplateCopyWithImpl<$Res>
    implements $IpalChecklistTemplateCopyWith<$Res> {
  _$IpalChecklistTemplateCopyWithImpl(this._self, this._then);

  final IpalChecklistTemplate _self;
  final $Res Function(IpalChecklistTemplate) _then;

/// Create a copy of IpalChecklistTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<IpalChecklistItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalChecklistTemplate].
extension IpalChecklistTemplatePatterns on IpalChecklistTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalChecklistTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalChecklistTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalChecklistTemplate value)  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalChecklistTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive,  List<IpalChecklistItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalChecklistTemplate() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive,  List<IpalChecklistItem> items)  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistTemplate():
return $default(_that.id,_that.name,_that.isActive,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'is_active')  bool isActive,  List<IpalChecklistItem> items)?  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistTemplate() when $default != null:
return $default(_that.id,_that.name,_that.isActive,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalChecklistTemplate implements IpalChecklistTemplate {
  const _IpalChecklistTemplate({required this.id, required this.name, @JsonKey(name: 'is_active') this.isActive = true, final  List<IpalChecklistItem> items = const <IpalChecklistItem>[]}): _items = items;
  factory _IpalChecklistTemplate.fromJson(Map<String, dynamic> json) => _$IpalChecklistTemplateFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  List<IpalChecklistItem> _items;
@override@JsonKey() List<IpalChecklistItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of IpalChecklistTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalChecklistTemplateCopyWith<_IpalChecklistTemplate> get copyWith => __$IpalChecklistTemplateCopyWithImpl<_IpalChecklistTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalChecklistTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalChecklistTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isActive,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'IpalChecklistTemplate(id: $id, name: $name, isActive: $isActive, items: $items)';
}


}

/// @nodoc
abstract mixin class _$IpalChecklistTemplateCopyWith<$Res> implements $IpalChecklistTemplateCopyWith<$Res> {
  factory _$IpalChecklistTemplateCopyWith(_IpalChecklistTemplate value, $Res Function(_IpalChecklistTemplate) _then) = __$IpalChecklistTemplateCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'is_active') bool isActive, List<IpalChecklistItem> items
});




}
/// @nodoc
class __$IpalChecklistTemplateCopyWithImpl<$Res>
    implements _$IpalChecklistTemplateCopyWith<$Res> {
  __$IpalChecklistTemplateCopyWithImpl(this._self, this._then);

  final _IpalChecklistTemplate _self;
  final $Res Function(_IpalChecklistTemplate) _then;

/// Create a copy of IpalChecklistTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isActive = null,Object? items = null,}) {
  return _then(_IpalChecklistTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<IpalChecklistItem>,
  ));
}


}


/// @nodoc
mixin _$IpalChecklistItem {

 int get id;@JsonKey(name: 'template_id') int? get templateId; String get name; String get category;@JsonKey(name: 'standard_condition') String? get standardCondition;@JsonKey(name: 'order_no') int? get orderNo;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of IpalChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpalChecklistItemCopyWith<IpalChecklistItem> get copyWith => _$IpalChecklistItemCopyWithImpl<IpalChecklistItem>(this as IpalChecklistItem, _$identity);

  /// Serializes this IpalChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpalChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.standardCondition, standardCondition) || other.standardCondition == standardCondition)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,templateId,name,category,standardCondition,orderNo,isActive);

@override
String toString() {
  return 'IpalChecklistItem(id: $id, templateId: $templateId, name: $name, category: $category, standardCondition: $standardCondition, orderNo: $orderNo, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $IpalChecklistItemCopyWith<$Res>  {
  factory $IpalChecklistItemCopyWith(IpalChecklistItem value, $Res Function(IpalChecklistItem) _then) = _$IpalChecklistItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'template_id') int? templateId, String name, String category,@JsonKey(name: 'standard_condition') String? standardCondition,@JsonKey(name: 'order_no') int? orderNo,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$IpalChecklistItemCopyWithImpl<$Res>
    implements $IpalChecklistItemCopyWith<$Res> {
  _$IpalChecklistItemCopyWithImpl(this._self, this._then);

  final IpalChecklistItem _self;
  final $Res Function(IpalChecklistItem) _then;

/// Create a copy of IpalChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? templateId = freezed,Object? name = null,Object? category = null,Object? standardCondition = freezed,Object? orderNo = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,standardCondition: freezed == standardCondition ? _self.standardCondition : standardCondition // ignore: cast_nullable_to_non_nullable
as String?,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [IpalChecklistItem].
extension IpalChecklistItemPatterns on IpalChecklistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpalChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpalChecklistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpalChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpalChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _IpalChecklistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'template_id')  int? templateId,  String name,  String category, @JsonKey(name: 'standard_condition')  String? standardCondition, @JsonKey(name: 'order_no')  int? orderNo, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpalChecklistItem() when $default != null:
return $default(_that.id,_that.templateId,_that.name,_that.category,_that.standardCondition,_that.orderNo,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'template_id')  int? templateId,  String name,  String category, @JsonKey(name: 'standard_condition')  String? standardCondition, @JsonKey(name: 'order_no')  int? orderNo, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistItem():
return $default(_that.id,_that.templateId,_that.name,_that.category,_that.standardCondition,_that.orderNo,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'template_id')  int? templateId,  String name,  String category, @JsonKey(name: 'standard_condition')  String? standardCondition, @JsonKey(name: 'order_no')  int? orderNo, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _IpalChecklistItem() when $default != null:
return $default(_that.id,_that.templateId,_that.name,_that.category,_that.standardCondition,_that.orderNo,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IpalChecklistItem implements IpalChecklistItem {
  const _IpalChecklistItem({required this.id, @JsonKey(name: 'template_id') this.templateId, required this.name, required this.category, @JsonKey(name: 'standard_condition') this.standardCondition, @JsonKey(name: 'order_no') this.orderNo, @JsonKey(name: 'is_active') this.isActive = true});
  factory _IpalChecklistItem.fromJson(Map<String, dynamic> json) => _$IpalChecklistItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'template_id') final  int? templateId;
@override final  String name;
@override final  String category;
@override@JsonKey(name: 'standard_condition') final  String? standardCondition;
@override@JsonKey(name: 'order_no') final  int? orderNo;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of IpalChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpalChecklistItemCopyWith<_IpalChecklistItem> get copyWith => __$IpalChecklistItemCopyWithImpl<_IpalChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IpalChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpalChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.standardCondition, standardCondition) || other.standardCondition == standardCondition)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,templateId,name,category,standardCondition,orderNo,isActive);

@override
String toString() {
  return 'IpalChecklistItem(id: $id, templateId: $templateId, name: $name, category: $category, standardCondition: $standardCondition, orderNo: $orderNo, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$IpalChecklistItemCopyWith<$Res> implements $IpalChecklistItemCopyWith<$Res> {
  factory _$IpalChecklistItemCopyWith(_IpalChecklistItem value, $Res Function(_IpalChecklistItem) _then) = __$IpalChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'template_id') int? templateId, String name, String category,@JsonKey(name: 'standard_condition') String? standardCondition,@JsonKey(name: 'order_no') int? orderNo,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$IpalChecklistItemCopyWithImpl<$Res>
    implements _$IpalChecklistItemCopyWith<$Res> {
  __$IpalChecklistItemCopyWithImpl(this._self, this._then);

  final _IpalChecklistItem _self;
  final $Res Function(_IpalChecklistItem) _then;

/// Create a copy of IpalChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? templateId = freezed,Object? name = null,Object? category = null,Object? standardCondition = freezed,Object? orderNo = freezed,Object? isActive = null,}) {
  return _then(_IpalChecklistItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,standardCondition: freezed == standardCondition ? _self.standardCondition : standardCondition // ignore: cast_nullable_to_non_nullable
as String?,orderNo: freezed == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
