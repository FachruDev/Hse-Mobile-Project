// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_field_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormFieldDefinition {

 int get id; String get label;@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType get inputType; String? get standard;@JsonKey(name: 'is_active') bool get isActive; List<FormSelectOption> get options;
/// Create a copy of FormFieldDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormFieldDefinitionCopyWith<FormFieldDefinition> get copyWith => _$FormFieldDefinitionCopyWithImpl<FormFieldDefinition>(this as FormFieldDefinition, _$identity);

  /// Serializes this FormFieldDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormFieldDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,inputType,standard,isActive,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'FormFieldDefinition(id: $id, label: $label, inputType: $inputType, standard: $standard, isActive: $isActive, options: $options)';
}


}

/// @nodoc
abstract mixin class $FormFieldDefinitionCopyWith<$Res>  {
  factory $FormFieldDefinitionCopyWith(FormFieldDefinition value, $Res Function(FormFieldDefinition) _then) = _$FormFieldDefinitionCopyWithImpl;
@useResult
$Res call({
 int id, String label,@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType inputType, String? standard,@JsonKey(name: 'is_active') bool isActive, List<FormSelectOption> options
});




}
/// @nodoc
class _$FormFieldDefinitionCopyWithImpl<$Res>
    implements $FormFieldDefinitionCopyWith<$Res> {
  _$FormFieldDefinitionCopyWithImpl(this._self, this._then);

  final FormFieldDefinition _self;
  final $Res Function(FormFieldDefinition) _then;

/// Create a copy of FormFieldDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? inputType = null,Object? standard = freezed,Object? isActive = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as HseInputType,standard: freezed == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<FormSelectOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [FormFieldDefinition].
extension FormFieldDefinitionPatterns on FormFieldDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormFieldDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormFieldDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormFieldDefinition value)  $default,){
final _that = this;
switch (_that) {
case _FormFieldDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormFieldDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _FormFieldDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'is_active')  bool isActive,  List<FormSelectOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormFieldDefinition() when $default != null:
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.isActive,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'is_active')  bool isActive,  List<FormSelectOption> options)  $default,) {final _that = this;
switch (_that) {
case _FormFieldDefinition():
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.isActive,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson)  HseInputType inputType,  String? standard, @JsonKey(name: 'is_active')  bool isActive,  List<FormSelectOption> options)?  $default,) {final _that = this;
switch (_that) {
case _FormFieldDefinition() when $default != null:
return $default(_that.id,_that.label,_that.inputType,_that.standard,_that.isActive,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormFieldDefinition implements FormFieldDefinition {
  const _FormFieldDefinition({required this.id, required this.label, @JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) required this.inputType, this.standard, @JsonKey(name: 'is_active') this.isActive = true, final  List<FormSelectOption> options = const <FormSelectOption>[]}): _options = options;
  factory _FormFieldDefinition.fromJson(Map<String, dynamic> json) => _$FormFieldDefinitionFromJson(json);

@override final  int id;
@override final  String label;
@override@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) final  HseInputType inputType;
@override final  String? standard;
@override@JsonKey(name: 'is_active') final  bool isActive;
 final  List<FormSelectOption> _options;
@override@JsonKey() List<FormSelectOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of FormFieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormFieldDefinitionCopyWith<_FormFieldDefinition> get copyWith => __$FormFieldDefinitionCopyWithImpl<_FormFieldDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormFieldDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormFieldDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.inputType, inputType) || other.inputType == inputType)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,inputType,standard,isActive,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'FormFieldDefinition(id: $id, label: $label, inputType: $inputType, standard: $standard, isActive: $isActive, options: $options)';
}


}

/// @nodoc
abstract mixin class _$FormFieldDefinitionCopyWith<$Res> implements $FormFieldDefinitionCopyWith<$Res> {
  factory _$FormFieldDefinitionCopyWith(_FormFieldDefinition value, $Res Function(_FormFieldDefinition) _then) = __$FormFieldDefinitionCopyWithImpl;
@override @useResult
$Res call({
 int id, String label,@JsonKey(name: 'input_type', fromJson: _inputTypeFromJson, toJson: _inputTypeToJson) HseInputType inputType, String? standard,@JsonKey(name: 'is_active') bool isActive, List<FormSelectOption> options
});




}
/// @nodoc
class __$FormFieldDefinitionCopyWithImpl<$Res>
    implements _$FormFieldDefinitionCopyWith<$Res> {
  __$FormFieldDefinitionCopyWithImpl(this._self, this._then);

  final _FormFieldDefinition _self;
  final $Res Function(_FormFieldDefinition) _then;

/// Create a copy of FormFieldDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? inputType = null,Object? standard = freezed,Object? isActive = null,Object? options = null,}) {
  return _then(_FormFieldDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,inputType: null == inputType ? _self.inputType : inputType // ignore: cast_nullable_to_non_nullable
as HseInputType,standard: freezed == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<FormSelectOption>,
  ));
}


}


/// @nodoc
mixin _$FormSelectOption {

 String get value; String get label;
/// Create a copy of FormSelectOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormSelectOptionCopyWith<FormSelectOption> get copyWith => _$FormSelectOptionCopyWithImpl<FormSelectOption>(this as FormSelectOption, _$identity);

  /// Serializes this FormSelectOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSelectOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,label);

@override
String toString() {
  return 'FormSelectOption(value: $value, label: $label)';
}


}

/// @nodoc
abstract mixin class $FormSelectOptionCopyWith<$Res>  {
  factory $FormSelectOptionCopyWith(FormSelectOption value, $Res Function(FormSelectOption) _then) = _$FormSelectOptionCopyWithImpl;
@useResult
$Res call({
 String value, String label
});




}
/// @nodoc
class _$FormSelectOptionCopyWithImpl<$Res>
    implements $FormSelectOptionCopyWith<$Res> {
  _$FormSelectOptionCopyWithImpl(this._self, this._then);

  final FormSelectOption _self;
  final $Res Function(FormSelectOption) _then;

/// Create a copy of FormSelectOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? label = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FormSelectOption].
extension FormSelectOptionPatterns on FormSelectOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormSelectOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormSelectOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormSelectOption value)  $default,){
final _that = this;
switch (_that) {
case _FormSelectOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormSelectOption value)?  $default,){
final _that = this;
switch (_that) {
case _FormSelectOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormSelectOption() when $default != null:
return $default(_that.value,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  String label)  $default,) {final _that = this;
switch (_that) {
case _FormSelectOption():
return $default(_that.value,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  String label)?  $default,) {final _that = this;
switch (_that) {
case _FormSelectOption() when $default != null:
return $default(_that.value,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormSelectOption implements FormSelectOption {
  const _FormSelectOption({required this.value, required this.label});
  factory _FormSelectOption.fromJson(Map<String, dynamic> json) => _$FormSelectOptionFromJson(json);

@override final  String value;
@override final  String label;

/// Create a copy of FormSelectOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormSelectOptionCopyWith<_FormSelectOption> get copyWith => __$FormSelectOptionCopyWithImpl<_FormSelectOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormSelectOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormSelectOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,label);

@override
String toString() {
  return 'FormSelectOption(value: $value, label: $label)';
}


}

/// @nodoc
abstract mixin class _$FormSelectOptionCopyWith<$Res> implements $FormSelectOptionCopyWith<$Res> {
  factory _$FormSelectOptionCopyWith(_FormSelectOption value, $Res Function(_FormSelectOption) _then) = __$FormSelectOptionCopyWithImpl;
@override @useResult
$Res call({
 String value, String label
});




}
/// @nodoc
class __$FormSelectOptionCopyWithImpl<$Res>
    implements _$FormSelectOptionCopyWith<$Res> {
  __$FormSelectOptionCopyWithImpl(this._self, this._then);

  final _FormSelectOption _self;
  final $Res Function(_FormSelectOption) _then;

/// Create a copy of FormSelectOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? label = null,}) {
  return _then(_FormSelectOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
