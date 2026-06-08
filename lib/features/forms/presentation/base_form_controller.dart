import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/storage/local_cache_service.dart';
import '../domain/entities/form_field_definition.dart';

abstract class BaseFormController {
  const BaseFormController({
    required LocalCacheService draftCache,
    required String draftKey,
  }) : _draftCache = draftCache,
       _draftKey = draftKey;

  final LocalCacheService _draftCache;
  final String _draftKey;

  FormGroup buildForm(List<FormFieldDefinition> fields) {
    final controls = <String, AbstractControl<dynamic>>{};
    final draft = _draftCache.readJsonMap(_draftKey) ?? const {};

    for (final field in fields.where((field) => field.isActive)) {
      final controlName = controlNameFor(field.id);
      controls[controlName] = FormControl<String>(
        value: draft[controlName]?.toString(),
      );
    }

    return FormGroup(controls);
  }

  String controlNameFor(int fieldId) => 'field_$fieldId';

  Future<void> saveDraft(FormGroup form) {
    return _draftCache.writeJson(_draftKey, form.value);
  }

  Future<void> clearDraft() => _draftCache.remove(_draftKey);
}
