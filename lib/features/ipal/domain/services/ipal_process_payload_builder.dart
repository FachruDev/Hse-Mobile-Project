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
            _fieldValue(item, draft.processValues, draft.processNotes),
      ],
    };
  }

  static List<Map<String, dynamic>> buildBatchPayload({
    required List<IpalProcessItem> batchItems,
    required List<IpalBatchDraft> batches,
  }) {
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
    Map<String, String> notes,
  ) {
    final rawValue = values[item.id.toString()]?.trim();
    final note = notes[item.id.toString()]?.trim();
    final isNumber = item.inputType == HseInputType.number;

    return {
      'item_id': item.id,
      'value_number': isNumber && rawValue?.isNotEmpty == true
          ? num.tryParse(rawValue!)
          : null,
      'value_text': !isNumber && rawValue?.isNotEmpty == true ? rawValue : null,
      'note': note?.isNotEmpty == true ? note : null,
    };
  }
}
