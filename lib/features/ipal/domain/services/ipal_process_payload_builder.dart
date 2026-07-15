import '../../../forms/domain/entities/form_field_definition.dart';
import '../entities/ipal_process_draft.dart';
import '../entities/ipal_process_master.dart';

class IpalProcessPayloadBuilder {
  const IpalProcessPayloadBuilder._();

  static Map<String, dynamic> buildProcessPayload({
    required IpalProcessTemplate template,
    required IpalProcessDraft draft,
  }) {
    return {
      'template_id': template.id,
      'values': [
        for (final section in template.sections)
          for (final item in section.items)
            _fieldValue(
              item,
              draft.processValues,
              draft.processNotes,
              draft.processAttachmentPaths,
            ),
      ],
    };
  }

  static List<Map<String, dynamic>> buildBatchPayload({
    required List<IpalProcessSection> batchSections,
    required List<IpalBatchDraft> batches,
  }) {
    final batchItems = [for (final section in batchSections) ...section.items];

    return [
      for (final batch in batches)
        {
          'batch_no': batch.batchNo,
          'values': [
            for (final item in batchItems)
              _fieldValue(item, batch.values, batch.notes),
          ],
        },
    ];
  }

  static Map<String, dynamic> _fieldValue(
    IpalProcessItem item,
    Map<String, String> values,
    Map<String, String> notes, [
    Map<String, String> attachmentPaths = const <String, String>{},
  ]) {
    final rawValue = values[item.id.toString()]?.trim();
    final note = notes[item.id.toString()]?.trim();
    final attachmentPath = attachmentPaths[item.id.toString()]?.trim();
    if (item.inputType == HseInputType.optionWithIntegerM3) {
      final optionValue = optionWithIntegerM3Option(rawValue);
      final numberValue = optionWithIntegerM3Number(rawValue);

      return {
        'item_id': item.id,
        'value_number': numberValue?.isNotEmpty == true
            ? num.tryParse(numberValue!)
            : null,
        'value_text': optionValue?.isNotEmpty == true ? optionValue : null,
        'note': note?.isNotEmpty == true ? note : null,
        'attachment_path': attachmentPath?.isNotEmpty == true
            ? attachmentPath
            : null,
      };
    }

    final isNumber = item.inputType.storesNumber;

    return {
      'item_id': item.id,
      'value_number': isNumber && rawValue?.isNotEmpty == true
          ? num.tryParse(rawValue!)
          : null,
      'value_text': !isNumber && rawValue?.isNotEmpty == true ? rawValue : null,
      'note': note?.isNotEmpty == true ? note : null,
      'attachment_path': attachmentPath?.isNotEmpty == true
          ? attachmentPath
          : null,
    };
  }
}

String encodeOptionWithIntegerM3Value(String option, String number) {
  final normalizedOption = option.trim();
  final normalizedNumber = number.trim();
  if (normalizedOption.isEmpty && normalizedNumber.isEmpty) return '';

  return '$normalizedOption|$normalizedNumber';
}

String? optionWithIntegerM3Option(String? rawValue) {
  final text = rawValue?.trim();
  if (text == null || text.isEmpty) return null;

  final separatorIndex = text.indexOf('|');
  if (separatorIndex < 0) return text;

  final option = text.substring(0, separatorIndex).trim();
  return option.isEmpty ? null : option;
}

String? optionWithIntegerM3Number(String? rawValue) {
  final text = rawValue?.trim();
  if (text == null || text.isEmpty) return null;

  final separatorIndex = text.indexOf('|');
  if (separatorIndex < 0) return null;

  final number = text.substring(separatorIndex + 1).trim();
  return number.isEmpty ? null : number;
}

extension on HseInputType {
  bool get storesNumber {
    return switch (this) {
      HseInputType.number ||
      HseInputType.decimal2 ||
      HseInputType.integer ||
      HseInputType.durationMinutes ||
      HseInputType.percentage => true,
      _ => false,
    };
  }
}
