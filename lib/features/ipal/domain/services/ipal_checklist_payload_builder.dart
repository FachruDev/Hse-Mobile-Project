import '../entities/ipal_checklist_draft.dart';
import '../entities/ipal_checklist_master.dart';

class IpalChecklistPayloadBuilder {
  const IpalChecklistPayloadBuilder._();

  static Map<String, dynamic> buildChecklistPayload({
    required IpalChecklistTemplate template,
    required IpalChecklistDraft draft,
  }) {
    return {
      'template_id': template.id,
      'values': [
        for (final item in template.items.where((item) => item.isActive))
          {
            'item_id': item.id,
            'status': draft.statuses[item.id.toString()],
            'note': _nullableText(draft.notes[item.id.toString()]),
            'attachment_path': _nullableText(
              draft.attachmentPaths[item.id.toString()],
            ),
          },
      ],
    };
  }

  static List<String> missingStatuses({
    required IpalChecklistTemplate template,
    required IpalChecklistDraft draft,
  }) {
    return [
      for (final item in template.items.where((item) => item.isActive))
        if ((draft.statuses[item.id.toString()] ?? '').isEmpty) item.name,
    ];
  }

  static String? _nullableText(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}
