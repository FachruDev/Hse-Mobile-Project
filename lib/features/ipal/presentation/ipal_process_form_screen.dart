import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../forms/domain/entities/form_field_definition.dart';
import '../application/ipal_process_master_controller.dart';
import '../data/ipal_process_repository_impl.dart';
import '../domain/entities/ipal_process_draft.dart';
import '../domain/entities/ipal_process_master.dart';
import '../domain/services/ipal_process_payload_builder.dart';
import 'widgets/ipal_form_tabs.dart';

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
  final _processAttachmentPaths = <String, String>{};
  final _batches = <IpalBatchDraft>[];
  final _imagePicker = ImagePicker();

  int? _selectedTemplateId;
  bool _draftLoaded = false;
  bool _saving = false;
  int _fieldRevision = 0;

  @override
  Widget build(BuildContext context) {
    final masterState = ref.watch(ipalProcessMasterProvider);

    return HseAppScaffold(
      title: 'Form IPAL',
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
          final batchSections = master.effectiveBatchSections;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const IpalFormTabs(selected: IpalFormTab.process),
                const SizedBox(height: 16),
                const _FormTitleCard(
                  title: 'Catatan Proses IPAL',
                  icon: Icons.fact_check_outlined,
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
                    attachmentPaths: _processAttachmentPaths,
                    onValueChanged: _setProcessValue,
                    onNoteChanged: _setProcessNote,
                    onPickAttachment: _pickProcessAttachment,
                    onRemoveAttachment: _removeProcessAttachment,
                  ),
                  const SizedBox(height: 12),
                ],
                _BatchMixingCard(
                  key: ValueKey('batch_$_fieldRevision'),
                  batchSections: batchSections,
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
                  onValidate: () => _validatePayload(template, batchSections),
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
    _selectedTemplateId = templateExists
        ? draft.templateId
        : master.templates.firstOrNull?.id;
    _processValues
      ..clear()
      ..addAll(draft.processValues);
    _processNotes
      ..clear()
      ..addAll(draft.processNotes);
    _processAttachmentPaths
      ..clear()
      ..addAll(draft.processAttachmentPaths);
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

  void _setProcessValue(int itemId, String value) {
    _processValues[itemId.toString()] = value;
  }

  void _setProcessNote(int itemId, String value) {
    _processNotes[itemId.toString()] = value;
  }

  Future<void> _pickProcessAttachment(int itemId, ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (image == null) return;

    setState(() {
      _processAttachmentPaths[itemId.toString()] = image.path;
      _fieldRevision++;
    });
  }

  void _removeProcessAttachment(int itemId) {
    setState(() {
      _processAttachmentPaths.remove(itemId.toString());
      _fieldRevision++;
    });
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
    List<IpalProcessSection> batchSections,
  ) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final draft = _draftFor(template);
    IpalProcessPayloadBuilder.buildProcessPayload(
      template: template,
      draft: draft,
    );
    IpalProcessPayloadBuilder.buildBatchPayload(
      batchSections: batchSections,
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
      _processAttachmentPaths.clear();
      _batches.clear();
      _fieldRevision++;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Draft lokal dihapus.')));
  }

  IpalProcessDraft _draftFor(IpalProcessTemplate template) {
    return IpalProcessDraft(
      tanggal: _todayLabel,
      templateId: template.id,
      processValues: Map<String, String>.from(_processValues),
      processNotes: Map<String, String>.from(_processNotes),
      processAttachmentPaths: Map<String, String>.from(_processAttachmentPaths),
      batches: List<IpalBatchDraft>.from(_batches),
    );
  }

  String get _todayLabel => _dateFormat.format(DateTime.now());
}

class _FormTitleCard extends StatelessWidget {
  const _FormTitleCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
    required this.attachmentPaths,
    required this.onValueChanged,
    required this.onNoteChanged,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    super.key,
  });

  final IpalProcessSection section;
  final Map<String, String> values;
  final Map<String, String> notes;
  final Map<String, String> attachmentPaths;
  final void Function(int itemId, String value) onValueChanged;
  final void Function(int itemId, String value) onNoteChanged;
  final Future<void> Function(int itemId, ImageSource source) onPickAttachment;
  final void Function(int itemId) onRemoveAttachment;

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
                attachmentPath: attachmentPaths[item.id.toString()],
                onValueChanged: (value) => onValueChanged(item.id, value),
                onNoteChanged: (value) => onNoteChanged(item.id, value),
                onPickGallery: () =>
                    onPickAttachment(item.id, ImageSource.gallery),
                onPickCamera: () =>
                    onPickAttachment(item.id, ImageSource.camera),
                onRemoveAttachment: () => onRemoveAttachment(item.id),
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
    required this.batchSections,
    required this.batches,
    required this.onAddBatch,
    required this.onRemoveBatch,
    required this.onValueChanged,
    required this.onNoteChanged,
    super.key,
  });

  final List<IpalProcessSection> batchSections;
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
                  onPressed: batchSections.isEmpty ? null : onAddBatch,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (batchSections.isEmpty) ...[
              const SizedBox(height: 12),
              const Text('Master item batch belum tersedia.'),
            ],
            if (batches.isEmpty && batchSections.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _EmptyBatchHint(),
            ],
            for (final batch in batches) ...[
              const SizedBox(height: 16),
              _BatchCard(
                batchSections: batchSections,
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
    required this.batchSections,
    required this.batch,
    required this.onRemove,
    required this.onValueChanged,
    required this.onNoteChanged,
  });

  final List<IpalProcessSection> batchSections;
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
            for (final section in batchSections) ...[
              _BatchSectionPanel(
                section: section,
                batch: batch,
                onValueChanged: onValueChanged,
                onNoteChanged: onNoteChanged,
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _BatchSectionPanel extends StatelessWidget {
  const _BatchSectionPanel({
    required this.section,
    required this.batch,
    required this.onValueChanged,
    required this.onNoteChanged,
  });

  final IpalProcessSection section;
  final IpalBatchDraft batch;
  final void Function(int itemId, String value) onValueChanged;
  final void Function(int itemId, String value) onNoteChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final item in section.items) ...[
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

class _DynamicProcessField extends StatefulWidget {
  const _DynamicProcessField({
    required this.item,
    required this.value,
    required this.note,
    required this.onValueChanged,
    required this.onNoteChanged,
    this.attachmentPath,
    this.onPickGallery,
    this.onPickCamera,
    this.onRemoveAttachment,
  });

  final IpalProcessItem item;
  final String? value;
  final String? note;
  final String? attachmentPath;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback? onPickGallery;
  final VoidCallback? onPickCamera;
  final VoidCallback? onRemoveAttachment;

  @override
  State<_DynamicProcessField> createState() => _DynamicProcessFieldState();
}

class _DynamicProcessFieldState extends State<_DynamicProcessField> {
  static const _manualValue = '__manual__';

  late final TextEditingController _manualController;
  late bool _isManual;

  @override
  void initState() {
    super.initState();
    _isManual = _shouldUseManual(widget.value);
    _manualController = TextEditingController(
      text: _isManual ? widget.value : null,
    );
  }

  @override
  void didUpdateWidget(covariant _DynamicProcessField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.item != widget.item) {
      _isManual = _shouldUseManual(widget.value);
      if (_isManual && _manualController.text != widget.value) {
        _manualController.text = widget.value ?? '';
      }
    }
  }

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNumber = widget.item.inputType == HseInputType.number;
    final isDropdown = _shouldRenderDropdown();
    final canAttach =
        widget.onPickGallery != null && widget.onPickCamera != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useWideLayout = constraints.maxWidth >= 680;
            final description = _ProcessDescription(
              label: widget.item.label,
              standard: widget.item.standard,
            );
            final inputs = _ProcessInputs(
              actualField: isDropdown
                  ? _buildDropdownField(context)
                  : _buildTextField(isNumber),
              note: widget.note,
              onNoteChanged: widget.onNoteChanged,
              attachmentPath: widget.attachmentPath,
              canAttach: canAttach,
              onPickGallery: widget.onPickGallery,
              onPickCamera: widget.onPickCamera,
              onRemoveAttachment: widget.onRemoveAttachment,
            );

            if (!useWideLayout) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [description, const SizedBox(height: 14), inputs],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: description),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: inputs),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(bool isNumber) {
    return TextFormField(
      initialValue: widget.value,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: isNumber ? 'Kondisi aktual (angka)' : 'Kondisi aktual',
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
      onChanged: widget.onValueChanged,
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    final options = _dropdownOptions();
    final values = options.map((option) => option.value).toSet();
    final selectedValue = _isManual
        ? _manualValue
        : values.contains(widget.value)
        ? widget.value
        : null;

    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          decoration: const InputDecoration(
            labelText: 'Kondisi aktual',
            prefixIcon: Icon(Icons.fact_check_outlined),
          ),
          items: [
            for (final option in options)
              DropdownMenuItem(value: option.value, child: Text(option.label)),
            if (widget.item.inputType == HseInputType.optionWithManual)
              const DropdownMenuItem(
                value: _manualValue,
                child: Text('Lainnya'),
              ),
          ],
          onChanged: (value) {
            if (value == null) return;
            if (value == _manualValue) {
              setState(() => _isManual = true);
              widget.onValueChanged(_manualController.text);
              return;
            }

            setState(() => _isManual = false);
            widget.onValueChanged(value);
          },
        ),
        if (_isManual) ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: _manualController,
            decoration: const InputDecoration(
              labelText: 'Isi kondisi aktual manual',
              prefixIcon: Icon(Icons.edit_note_outlined),
            ),
            validator: (value) {
              if (_isManual && (value == null || value.trim().isEmpty)) {
                return 'Kondisi manual wajib diisi.';
              }
              return null;
            },
            onChanged: widget.onValueChanged,
          ),
        ],
      ],
    );
  }

  List<FormSelectOption> _dropdownOptions() {
    if (widget.item.options.isNotEmpty) return widget.item.options;

    final standard = widget.item.standard?.trim();
    final standardLabel = standard?.isNotEmpty == true
        ? standard!
        : 'Sesuai standar';

    if (widget.item.inputType == HseInputType.optionStandard ||
        widget.item.inputType == HseInputType.optionWithManual) {
      return [
        FormSelectOption(value: standardLabel, label: standardLabel),
        const FormSelectOption(
          value: 'Tidak sesuai standar',
          label: 'Tidak sesuai standar',
        ),
        const FormSelectOption(value: 'Tidak berlaku', label: 'Tidak berlaku'),
      ];
    }

    return const [];
  }

  bool _shouldUseManual(String? value) {
    if (widget.item.inputType != HseInputType.optionWithManual) return false;
    final text = value?.trim();
    if (text == null || text.isEmpty) return false;
    return !_dropdownOptions().any((option) => option.value == text);
  }

  bool _shouldRenderDropdown() {
    if (widget.item.inputType == HseInputType.optionStandard ||
        widget.item.inputType == HseInputType.optionWithManual) {
      return true;
    }

    return widget.item.inputType == HseInputType.dropdown &&
        widget.item.options.isNotEmpty;
  }
}

class _ProcessDescription extends StatelessWidget {
  const _ProcessDescription({required this.label, required this.standard});

  final String label;
  final String? standard;

  @override
  Widget build(BuildContext context) {
    final hasStandard = standard?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(
          icon: Icons.format_list_bulleted_outlined,
          label: 'Uraian Proses',
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        const _FieldLabel(
          icon: Icons.task_alt_outlined,
          label: 'Kondisi Standar',
        ),
        const SizedBox(height: 6),
        _StandardConditionBox(
          standard: hasStandard ? standard! : 'Belum ada kondisi standar.',
        ),
      ],
    );
  }
}

class _ProcessInputs extends StatelessWidget {
  const _ProcessInputs({
    required this.actualField,
    required this.note,
    required this.onNoteChanged,
    required this.attachmentPath,
    required this.canAttach,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemoveAttachment,
  });

  final Widget actualField;
  final String? note;
  final ValueChanged<String> onNoteChanged;
  final String? attachmentPath;
  final bool canAttach;
  final VoidCallback? onPickGallery;
  final VoidCallback? onPickCamera;
  final VoidCallback? onRemoveAttachment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(
          icon: Icons.fact_check_outlined,
          label: 'Kondisi Aktual',
        ),
        const SizedBox(height: 8),
        actualField,
        const SizedBox(height: 12),
        const _FieldLabel(icon: Icons.comment_outlined, label: 'Keterangan'),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: note,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Keterangan opsional',
            prefixIcon: Icon(Icons.comment_outlined),
          ),
          onChanged: onNoteChanged,
        ),
        if (canAttach) ...[
          const SizedBox(height: 12),
          const _FieldLabel(icon: Icons.photo_camera_outlined, label: 'Foto'),
          const SizedBox(height: 8),
          _ProcessAttachmentPicker(
            attachmentPath: attachmentPath,
            onPickGallery: onPickGallery!,
            onPickCamera: onPickCamera!,
            onRemove: onRemoveAttachment!,
          ),
        ],
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StandardConditionBox extends StatelessWidget {
  const _StandardConditionBox({required this.standard});

  final String standard;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.task_alt_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kondisi standar: $standard',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessAttachmentPicker extends StatelessWidget {
  const _ProcessAttachmentPicker({
    required this.attachmentPath,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  final String? attachmentPath;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final fileName = _fileName(attachmentPath);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_file_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName ?? 'Foto opsional',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (fileName != null)
                  IconButton(
                    tooltip: 'Hapus foto',
                    onPressed: onRemove,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onPickGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeri'),
                ),
                OutlinedButton.icon(
                  onPressed: onPickCamera,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Kamera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _fileName(String? path) {
    if (path == null || path.isEmpty) return null;

    return path.split(RegExp(r'[\\/]')).last;
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

extension on IpalProcessMaster {
  List<IpalProcessSection> get effectiveBatchSections {
    if (batchSections.isNotEmpty) return batchSections;
    if (batchItems.isEmpty) return const [];

    return [IpalProcessSection(id: 0, name: 'Batch Mixing', items: batchItems)];
  }
}
