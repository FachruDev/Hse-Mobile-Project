import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../application/ipal_checklist_master_controller.dart';
import '../data/ipal_checklist_repository_impl.dart';
import '../data/ipal_log_repository.dart';
import '../data/ipal_process_repository_impl.dart';
import '../domain/entities/ipal_checklist_draft.dart';
import '../domain/entities/ipal_checklist_master.dart';
import '../domain/entities/ipal_process_master.dart';
import '../domain/services/ipal_checklist_payload_builder.dart';
import '../domain/services/ipal_log_payload_builder.dart';

class IpalChecklistFormScreen extends ConsumerStatefulWidget {
  const IpalChecklistFormScreen({super.key});

  @override
  ConsumerState<IpalChecklistFormScreen> createState() =>
      _IpalChecklistFormScreenState();
}

class _IpalChecklistFormScreenState
    extends ConsumerState<IpalChecklistFormScreen> {
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _statuses = <String, String>{};
  final _notes = <String, String>{};
  final _attachmentPaths = <String, String>{};
  final _imagePicker = ImagePicker();

  DateTime _selectedDate = DateTime.now();
  int? _selectedTemplateId;
  bool _draftLoaded = false;
  bool _saving = false;
  bool _submitting = false;
  int _fieldRevision = 0;

  @override
  Widget build(BuildContext context) {
    final templatesState = ref.watch(ipalChecklistTemplatesProvider);

    return HseAppScaffold(
      title: 'Checklist Pemeriksaan Harian',
      selectedPath: '/form/ipal/checklist',
      showBackButton: true,
      body: templatesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'Master checklist belum bisa dimuat: $error',
          onRetry: () => ref.invalidate(ipalChecklistTemplatesProvider),
        ),
        data: (templates) {
          _loadDraftOnce(templates);
          final template = _selectedTemplate(templates);
          if (template == null) return const _EmptyChecklistState();

          final activeItems = template.items
              .where((item) => item.isActive)
              .toList(growable: false);
          final groupedItems = _groupItems(activeItems);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderCard(
                dateLabel: _dateFormat.format(_selectedDate),
                templates: templates,
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
              _ChecklistCompletionPanel(
                items: activeItems,
                statuses: _statuses,
              ),
              const SizedBox(height: 16),
              for (final entry in groupedItems.entries) ...[
                _ChecklistCategoryCard(
                  key: ValueKey('${entry.key}_$_fieldRevision'),
                  category: entry.key,
                  items: entry.value,
                  statuses: _statuses,
                  notes: _notes,
                  attachmentPaths: _attachmentPaths,
                  onStatusChanged: _setStatus,
                  onNoteChanged: _setNote,
                  onPickAttachment: _pickAttachment,
                  onRemoveAttachment: _removeAttachment,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              _ActionBar(
                saving: _saving,
                submitting: _submitting,
                onSaveDraft: () => _saveDraft(template),
                onSendDraft: () => _sendIpalLog(template, 'DRAFT'),
                onSubmit: () => _sendIpalLog(template, 'SUBMIT'),
                onReset: _resetDraft,
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  void _loadDraftOnce(List<IpalChecklistTemplate> templates) {
    if (_draftLoaded) return;
    _draftLoaded = true;

    final draft = ref.read(ipalChecklistRepositoryProvider).readDraft();
    if (draft == null) {
      _selectedTemplateId = templates.firstOrNull?.id;
      return;
    }

    final templateExists = templates.any(
      (template) => template.id == draft.templateId,
    );
    _selectedDate = DateTime.tryParse(draft.tanggal) ?? DateTime.now();
    _selectedTemplateId = templateExists
        ? draft.templateId
        : templates.firstOrNull?.id;
    _statuses
      ..clear()
      ..addAll(draft.statuses);
    _notes
      ..clear()
      ..addAll(draft.notes);
    _attachmentPaths
      ..clear()
      ..addAll(draft.attachmentPaths);
    _fieldRevision++;
  }

  IpalChecklistTemplate? _selectedTemplate(
    List<IpalChecklistTemplate> templates,
  ) {
    if (templates.isEmpty) return null;
    final selectedId = _selectedTemplateId ?? templates.first.id;
    return templates.firstWhere(
      (template) => template.id == selectedId,
      orElse: () => templates.first,
    );
  }

  Map<String, List<IpalChecklistItem>> _groupItems(
    List<IpalChecklistItem> items,
  ) {
    final grouped = <String, List<IpalChecklistItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
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

  void _setStatus(int itemId, String value) {
    setState(() {
      if (value.isEmpty) {
        _statuses.remove(itemId.toString());
        return;
      }

      _statuses[itemId.toString()] = value;
    });
  }

  void _setNote(int itemId, String value) {
    _notes[itemId.toString()] = value;
  }

  Future<void> _pickAttachment(int itemId, ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (image == null) return;

    setState(() {
      _attachmentPaths[itemId.toString()] = image.path;
      _fieldRevision++;
    });
  }

  void _removeAttachment(int itemId) {
    setState(() {
      _attachmentPaths.remove(itemId.toString());
      _fieldRevision++;
    });
  }

  Future<void> _saveDraft(IpalChecklistTemplate template) async {
    setState(() => _saving = true);
    await ref
        .read(ipalChecklistRepositoryProvider)
        .saveDraft(_draftFor(template));
    if (!mounted) return;
    setState(() => _saving = false);
    _showMessage('Draft checklist berhasil disimpan.');
  }

  Future<void> _sendIpalLog(
    IpalChecklistTemplate checklistTemplate,
    String action,
  ) async {
    final checklistDraft = _draftFor(checklistTemplate);
    final missing = IpalChecklistPayloadBuilder.missingStatuses(
      template: checklistTemplate,
      draft: checklistDraft,
    );
    if (missing.isNotEmpty) {
      _showMessage('Masih ada item checklist yang belum diisi.');
      return;
    }

    final processRepository = ref.read(ipalProcessRepositoryProvider);
    final processDraft = processRepository.readDraft();
    if (processDraft == null) {
      _showMessage('Draft Catatan Proses IPAL belum tersedia.');
      return;
    }
    if (processDraft.tanggal != checklistDraft.tanggal) {
      _showMessage(
        'Tanggal checklist dan catatan proses harus sama sebelum dikirim.',
      );
      return;
    }

    setState(() => _submitting = true);
    Map<String, dynamic>? payload;
    try {
      final processMaster = await processRepository.getProcessMaster();
      final processTemplate = processMaster.templates.firstWhere(
        (template) => template.id == processDraft.templateId,
        orElse: () => processMaster.templates.first,
      );
      payload = IpalLogPayloadBuilder.build(
        action: action,
        checklistTemplate: checklistTemplate,
        checklistDraft: checklistDraft,
        processTemplate: processTemplate,
        processDraft: processDraft,
        batchSections: processMaster.effectiveBatchSections,
      );

      await ref.read(ipalLogRepositoryProvider).createLog(payload);
      await ref.read(ipalChecklistRepositoryProvider).clearDraft();
      await processRepository.clearDraft();
      if (!mounted) return;
      _statuses.clear();
      _notes.clear();
      _attachmentPaths.clear();
      setState(() {
        _submitting = false;
        _fieldRevision++;
      });
      _showMessage(
        action == 'SUBMIT'
            ? 'Log IPAL berhasil di-submit.'
            : 'Draft IPAL berhasil dikirim ke server.',
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      if (payload != null && _canQueue(error)) {
        await _enqueueIpalLog(payload);
        _showMessage(
          'Koneksi belum stabil. Payload IPAL disimpan ke antrean submit.',
        );
        return;
      }
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showMessage('Log IPAL gagal dikirim: $error');
    }
  }

  Future<void> _resetDraft() async {
    await ref.read(ipalChecklistRepositoryProvider).clearDraft();
    setState(() {
      _statuses.clear();
      _notes.clear();
      _attachmentPaths.clear();
      _selectedDate = DateTime.now();
      _fieldRevision++;
    });
    _showMessage('Draft checklist lokal dihapus.');
  }

  IpalChecklistDraft _draftFor(IpalChecklistTemplate template) {
    return IpalChecklistDraft(
      tanggal: _dateFormat.format(_selectedDate),
      templateId: template.id,
      statuses: Map<String, String>.from(_statuses),
      notes: Map<String, String>.from(_notes),
      attachmentPaths: Map<String, String>.from(_attachmentPaths),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _canQueue(ApiException error) {
    final statusCode = error.statusCode;
    return statusCode == null || statusCode >= 500;
  }

  Future<void> _enqueueIpalLog(Map<String, dynamic> payload) {
    return ref
        .read(submitQueueServiceProvider)
        .enqueue(
          SubmitQueueItem(
            id: 'ipal-${DateTime.now().microsecondsSinceEpoch}',
            endpoint: '/ipal/logs',
            method: 'POST',
            payload: payload,
            createdAt: DateTime.now(),
          ),
        );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.dateLabel,
    required this.templates,
    required this.selectedTemplateId,
    required this.onPickDate,
    required this.onTemplateChanged,
  });

  final String dateLabel;
  final List<IpalChecklistTemplate> templates;
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
              'Informasi Checklist',
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
                labelText: 'Template Checklist',
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

class _ChecklistCompletionPanel extends StatelessWidget {
  const _ChecklistCompletionPanel({
    required this.items,
    required this.statuses,
  });

  final List<IpalChecklistItem> items;
  final Map<String, String> statuses;

  @override
  Widget build(BuildContext context) {
    final completedItems = items
        .where((item) => (statuses[item.id.toString()] ?? '').isNotEmpty)
        .toList(growable: false);
    final missingItems = items
        .where((item) => (statuses[item.id.toString()] ?? '').isEmpty)
        .toList(growable: false);
    final total = items.length;
    final completed = completedItems.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment_turned_in_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Laporan Kelengkapan Checklist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$completed/$total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: Colors.red.withValues(alpha: 0.16),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 12),
            _CompletionGroup(
              title: 'Belum diisi',
              color: Colors.red,
              icon: Icons.error_outline,
              items: missingItems,
              emptyText: 'Semua item sudah diisi.',
            ),
            const SizedBox(height: 10),
            _CompletionGroup(
              title: 'Sudah diisi',
              color: Colors.green,
              icon: Icons.check_circle_outline,
              items: completedItems,
              emptyText: 'Belum ada item yang diisi.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionGroup extends StatelessWidget {
  const _CompletionGroup({
    required this.title,
    required this.color,
    required this.icon,
    required this.items,
    required this.emptyText,
  });

  final String title;
  final Color color;
  final IconData icon;
  final List<IpalChecklistItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              '$title (${items.length})',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(emptyText, style: Theme.of(context).textTheme.bodySmall)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in items)
                Chip(
                  label: Text(item.name, overflow: TextOverflow.ellipsis),
                  avatar: Icon(icon, color: color, size: 16),
                  side: BorderSide(color: color.withValues(alpha: 0.35)),
                  backgroundColor: color.withValues(alpha: 0.08),
                  labelStyle: TextStyle(color: color),
                ),
            ],
          ),
      ],
    );
  }
}

class _ChecklistCategoryCard extends StatelessWidget {
  const _ChecklistCategoryCard({
    required this.category,
    required this.items,
    required this.statuses,
    required this.notes,
    required this.attachmentPaths,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    super.key,
  });

  final String category;
  final List<IpalChecklistItem> items;
  final Map<String, String> statuses;
  final Map<String, String> notes;
  final Map<String, String> attachmentPaths;
  final void Function(int itemId, String value) onStatusChanged;
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
            Text(category, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            for (final item in items) ...[
              _ChecklistItemField(
                item: item,
                status: statuses[item.id.toString()],
                note: notes[item.id.toString()],
                attachmentPath: attachmentPaths[item.id.toString()],
                isComplete: (statuses[item.id.toString()] ?? '').isNotEmpty,
                onStatusChanged: (value) => onStatusChanged(item.id, value),
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

class _ChecklistItemField extends StatelessWidget {
  const _ChecklistItemField({
    required this.item,
    required this.status,
    required this.note,
    required this.attachmentPath,
    required this.isComplete,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemoveAttachment,
  });

  final IpalChecklistItem item;
  final String? status;
  final String? note;
  final String? attachmentPath;
  final bool isComplete;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onRemoveAttachment;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (isComplete ? Colors.green : Colors.red).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isComplete ? Colors.green : Colors.red).withValues(
            alpha: 0.38,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(isComplete ? 'Sudah diisi' : 'Belum diisi'),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(
                    color: (isComplete ? Colors.green : Colors.red).withValues(
                      alpha: 0.35,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isComplete ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (item.standardCondition?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                'Kondisi standar: ${item.standardCondition}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: status?.isEmpty == true ? null : status,
              decoration: const InputDecoration(
                labelText: 'Status aktual',
                prefixIcon: Icon(Icons.fact_check_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'OK', child: Text('Ya')),
                DropdownMenuItem(value: 'NOT_OK', child: Text('Tidak')),
              ],
              onChanged: (value) {
                if (value != null) onStatusChanged(value);
              },
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            _ChecklistAttachmentPicker(
              attachmentPath: attachmentPath,
              onPickGallery: onPickGallery,
              onPickCamera: onPickCamera,
              onRemove: onRemoveAttachment,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistAttachmentPicker extends StatelessWidget {
  const _ChecklistAttachmentPicker({
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
        color: Colors.white,
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
                    fileName ?? 'Lampiran foto opsional',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (fileName != null)
                  IconButton(
                    tooltip: 'Hapus lampiran',
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
    required this.submitting,
    required this.onSaveDraft,
    required this.onSendDraft,
    required this.onSubmit,
    required this.onReset,
  });

  final bool saving;
  final bool submitting;
  final VoidCallback onSaveDraft;
  final VoidCallback onSendDraft;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: saving || submitting ? null : onSaveDraft,
          icon: saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: const Text('Simpan Draft Checklist'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: submitting ? null : onSendDraft,
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('Kirim Sebagai Draft IPAL'),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: submitting ? null : onSubmit,
          icon: submitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_outlined),
          label: const Text('Submit Log IPAL'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: submitting ? null : onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Draft Checklist'),
        ),
      ],
    );
  }
}

class _EmptyChecklistState extends StatelessWidget {
  const _EmptyChecklistState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('Master checklist belum tersedia.'),
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
