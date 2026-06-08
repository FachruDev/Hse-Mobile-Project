import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../forms/domain/entities/form_field_definition.dart';
import '../application/ipal_process_master_controller.dart';
import '../data/ipal_process_repository_impl.dart';
import '../domain/entities/ipal_process_draft.dart';
import '../domain/entities/ipal_process_master.dart';
import '../domain/services/ipal_process_payload_builder.dart';

class IpalProcessFormScreen extends ConsumerStatefulWidget {
  const IpalProcessFormScreen({super.key});

  @override
  ConsumerState<IpalProcessFormScreen> createState() =>
      _IpalProcessFormScreenState();
}

class _IpalProcessFormScreenState extends ConsumerState<IpalProcessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _processValues = <String, String>{};
  final _processNotes = <String, String>{};
  final _batches = <IpalBatchDraft>[];

  DateTime _selectedDate = DateTime.now();
  int? _selectedTemplateId;
  bool _draftLoaded = false;
  bool _saving = false;
  int _fieldRevision = 0;

  @override
  Widget build(BuildContext context) {
    final masterState = ref.watch(ipalProcessMasterProvider);

    return HseAppScaffold(
      title: 'Catatan Proses IPAL',
      selectedPath: '/form/ipal/proses',
      showBackButton: true,
      body: masterState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'Master catatan proses belum bisa dimuat: $error',
          onRetry: () => ref.invalidate(ipalProcessMasterProvider),
        ),
        data: (master) {
          _loadDraftOnce(master);

          final template = _selectedTemplate(master);
          if (template == null) return const _EmptyMasterState();

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderCard(
                  selectedDate: _selectedDate,
                  dateLabel: _dateFormat.format(_selectedDate),
                  templates: master.templates,
                  selectedTemplateId: template.id,
                  onPickDate: _pickDate,
                  onTemplateChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedTemplateId = value;
                      _fieldRevision++;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const _SubmitNotice(),
                const SizedBox(height: 16),
                for (final section in template.sections) ...[
                  _ProcessSectionCard(
                    key: ValueKey('section_${section.id}_$_fieldRevision'),
                    section: section,
                    values: _processValues,
                    notes: _processNotes,
                    onValueChanged: _setProcessValue,
                    onNoteChanged: _setProcessNote,
                  ),
                  const SizedBox(height: 12),
                ],
                _BatchMixingCard(
                  key: ValueKey('batch_$_fieldRevision'),
                  batchItems: master.batchItems,
                  batches: _batches,
                  onAddBatch: _addBatch,
                  onRemoveBatch: _removeBatch,
                  onValueChanged: _setBatchValue,
                  onNoteChanged: _setBatchNote,
                ),
                const SizedBox(height: 20),
                _ActionBar(
                  saving: _saving,
                  onSaveDraft: () => _saveDraft(template),
                  onValidate: () =>
                      _validatePayload(template, master.batchItems),
                  onReset: _resetDraft,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _loadDraftOnce(IpalProcessMaster master) {
    if (_draftLoaded) return;
    _draftLoaded = true;

    final draft = ref.read(ipalProcessRepositoryProvider).readDraft();
    if (draft == null) {
      _selectedTemplateId = master.templates.firstOrNull?.id;
      return;
    }

    final templateExists = master.templates.any(
      (template) => template.id == draft.templateId,
    );
    _selectedDate = DateTime.tryParse(draft.tanggal) ?? DateTime.now();
    _selectedTemplateId = templateExists
        ? draft.templateId
        : master.templates.firstOrNull?.id;
    _processValues
      ..clear()
      ..addAll(draft.processValues);
    _processNotes
      ..clear()
      ..addAll(draft.processNotes);
    _batches
      ..clear()
      ..addAll(draft.batches);
    _fieldRevision++;
  }

  IpalProcessTemplate? _selectedTemplate(IpalProcessMaster master) {
    if (master.templates.isEmpty) return null;
    final selectedId = _selectedTemplateId ?? master.templates.first.id;
    return master.templates.firstWhere(
      (template) => template.id == selectedId,
      orElse: () => master.templates.first,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
  }

  void _setProcessValue(int itemId, String value) {
    _processValues[itemId.toString()] = value;
  }

  void _setProcessNote(int itemId, String value) {
    _processNotes[itemId.toString()] = value;
  }

  void _addBatch() {
    final nextBatchNo = _batches.isEmpty
        ? 1
        : _batches
                  .map((batch) => batch.batchNo)
                  .reduce((a, b) => a > b ? a : b) +
              1;
    setState(() {
      _batches.add(IpalBatchDraft(batchNo: nextBatchNo));
      _fieldRevision++;
    });
  }

  void _removeBatch(int batchNo) {
    setState(() {
      _batches.removeWhere((batch) => batch.batchNo == batchNo);
      _fieldRevision++;
    });
  }

  void _setBatchValue(int batchNo, int itemId, String value) {
    final index = _batches.indexWhere((batch) => batch.batchNo == batchNo);
    if (index < 0) return;
    final values = Map<String, String>.from(_batches[index].values);
    values[itemId.toString()] = value;
    _batches[index] = _batches[index].copyWith(values: values);
  }

  void _setBatchNote(int batchNo, int itemId, String value) {
    final index = _batches.indexWhere((batch) => batch.batchNo == batchNo);
    if (index < 0) return;
    final notes = Map<String, String>.from(_batches[index].notes);
    notes[itemId.toString()] = value;
    _batches[index] = _batches[index].copyWith(notes: notes);
  }

  Future<void> _saveDraft(IpalProcessTemplate template) async {
    setState(() => _saving = true);
    final draft = _draftFor(template);
    await ref.read(ipalProcessRepositoryProvider).saveDraft(draft);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft catatan proses berhasil disimpan.')),
    );
  }

  void _validatePayload(
    IpalProcessTemplate template,
    List<IpalProcessItem> batchItems,
  ) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final draft = _draftFor(template);
    IpalProcessPayloadBuilder.buildProcessPayload(
      template: template,
      draft: draft,
    );
    IpalProcessPayloadBuilder.buildBatchPayload(
      batchItems: batchItems,
      batches: draft.batches,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan proses dan batch mixing valid.')),
    );
  }

  Future<void> _resetDraft() async {
    await ref.read(ipalProcessRepositoryProvider).clearDraft();
    setState(() {
      _processValues.clear();
      _processNotes.clear();
      _batches.clear();
      _selectedDate = DateTime.now();
      _fieldRevision++;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Draft lokal dihapus.')));
  }

  IpalProcessDraft _draftFor(IpalProcessTemplate template) {
    return IpalProcessDraft(
      tanggal: _dateFormat.format(_selectedDate),
      templateId: template.id,
      processValues: Map<String, String>.from(_processValues),
      processNotes: Map<String, String>.from(_processNotes),
      batches: List<IpalBatchDraft>.from(_batches),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.selectedDate,
    required this.dateLabel,
    required this.templates,
    required this.selectedTemplateId,
    required this.onPickDate,
    required this.onTemplateChanged,
  });

  final DateTime selectedDate;
  final String dateLabel;
  final List<IpalProcessTemplate> templates;
  final int selectedTemplateId;
  final VoidCallback onPickDate;
  final ValueChanged<int?> onTemplateChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Log',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onPickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('Tanggal: $dateLabel'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              initialValue: selectedTemplateId,
              decoration: const InputDecoration(
                labelText: 'Template Catatan Proses',
                prefixIcon: Icon(Icons.view_list_outlined),
              ),
              items: [
                for (final template in templates)
                  DropdownMenuItem(
                    value: template.id,
                    child: Text(template.name),
                  ),
              ],
              onChanged: onTemplateChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitNotice extends StatelessWidget {
  const _SubmitNotice();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Draft disimpan lokal terlebih dahulu. Submit ke server akan diaktifkan setelah Checklist Pemeriksaan Harian digabung dalam satu log IPAL.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessSectionCard extends StatelessWidget {
  const _ProcessSectionCard({
    required this.section,
    required this.values,
    required this.notes,
    required this.onValueChanged,
    required this.onNoteChanged,
    super.key,
  });

  final IpalProcessSection section;
  final Map<String, String> values;
  final Map<String, String> notes;
  final void Function(int itemId, String value) onValueChanged;
  final void Function(int itemId, String value) onNoteChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            for (final item in section.items) ...[
              _DynamicProcessField(
                item: item,
                value: values[item.id.toString()],
                note: notes[item.id.toString()],
                onValueChanged: (value) => onValueChanged(item.id, value),
                onNoteChanged: (value) => onNoteChanged(item.id, value),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _BatchMixingCard extends StatelessWidget {
  const _BatchMixingCard({
    required this.batchItems,
    required this.batches,
    required this.onAddBatch,
    required this.onRemoveBatch,
    required this.onValueChanged,
    required this.onNoteChanged,
    super.key,
  });

  final List<IpalProcessItem> batchItems;
  final List<IpalBatchDraft> batches;
  final VoidCallback onAddBatch;
  final ValueChanged<int> onRemoveBatch;
  final void Function(int batchNo, int itemId, String value) onValueChanged;
  final void Function(int batchNo, int itemId, String value) onNoteChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batch Mixing',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Opsional, isi hanya saat ada proses mixing.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Tambah Batch',
                  onPressed: batchItems.isEmpty ? null : onAddBatch,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (batchItems.isEmpty) ...[
              const SizedBox(height: 12),
              const Text('Master item batch belum tersedia.'),
            ],
            if (batches.isEmpty && batchItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _EmptyBatchHint(),
            ],
            for (final batch in batches) ...[
              const SizedBox(height: 16),
              _BatchCard(
                batchItems: batchItems,
                batch: batch,
                onRemove: () => onRemoveBatch(batch.batchNo),
                onValueChanged: (itemId, value) =>
                    onValueChanged(batch.batchNo, itemId, value),
                onNoteChanged: (itemId, value) =>
                    onNoteChanged(batch.batchNo, itemId, value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({
    required this.batchItems,
    required this.batch,
    required this.onRemove,
    required this.onValueChanged,
    required this.onNoteChanged,
  });

  final List<IpalProcessItem> batchItems;
  final IpalBatchDraft batch;
  final VoidCallback onRemove;
  final void Function(int itemId, String value) onValueChanged;
  final void Function(int itemId, String value) onNoteChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Batch ${batch.batchNo}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus Batch',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final item in batchItems) ...[
              _DynamicProcessField(
                item: item,
                value: batch.values[item.id.toString()],
                note: batch.notes[item.id.toString()],
                onValueChanged: (value) => onValueChanged(item.id, value),
                onNoteChanged: (value) => onNoteChanged(item.id, value),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _DynamicProcessField extends StatelessWidget {
  const _DynamicProcessField({
    required this.item,
    required this.value,
    required this.note,
    required this.onValueChanged,
    required this.onNoteChanged,
  });

  final IpalProcessItem item;
  final String? value;
  final String? note;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String> onNoteChanged;

  @override
  Widget build(BuildContext context) {
    final isNumber = item.inputType == HseInputType.number;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: item.label,
            helperText: item.standard,
            prefixIcon: Icon(isNumber ? Icons.pin_outlined : Icons.notes),
          ),
          validator: (input) {
            final text = input?.trim() ?? '';
            if (text.isEmpty) return null;
            if (isNumber && num.tryParse(text) == null) {
              return 'Isi angka yang valid.';
            }
            return null;
          },
          onChanged: onValueChanged,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: note,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Catatan opsional',
            prefixIcon: Icon(Icons.comment_outlined),
          ),
          onChanged: onNoteChanged,
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.saving,
    required this.onSaveDraft,
    required this.onValidate,
    required this.onReset,
  });

  final bool saving;
  final VoidCallback onSaveDraft;
  final VoidCallback onValidate;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: saving ? null : onSaveDraft,
          icon: saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: const Text('Simpan Draft Lokal'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onValidate,
          icon: const Icon(Icons.rule_outlined),
          label: const Text('Validasi Catatan Proses'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Draft'),
        ),
      ],
    );
  }
}

class _EmptyBatchHint extends StatelessWidget {
  const _EmptyBatchHint();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.textSecondary),
            SizedBox(width: 10),
            Expanded(child: Text('Belum ada batch mixing pada log ini.')),
          ],
        ),
      ),
    );
  }
}

class _EmptyMasterState extends StatelessWidget {
  const _EmptyMasterState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Master catatan proses belum tersedia.'),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 42),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Muat Ulang'),
            ),
          ],
        ),
      ),
    );
  }
}
