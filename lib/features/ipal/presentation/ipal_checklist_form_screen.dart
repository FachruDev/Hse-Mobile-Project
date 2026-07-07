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
import 'widgets/ipal_floating_scroll_controls.dart';
import 'widgets/ipal_form_tabs.dart';
import 'widgets/ipal_value_toggle.dart';

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
  final _scrollController = ScrollController();

  int? _selectedTemplateId;
  bool _draftLoaded = false;
  bool _saving = false;
  bool _submitting = false;
  int _fieldRevision = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templatesState = ref.watch(ipalChecklistTemplatesProvider);

    return HseAppScaffold(
      title: 'Form IPAL',
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

          return Stack(
            children: [
              ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                children: [
                  const IpalFormTabs(selected: IpalFormTab.checklist),
                  const SizedBox(height: 16),
                  _FormTitleCard(
                    title: 'Checklist Harian',
                    icon: Icons.checklist_outlined,
                  ),
                  const SizedBox(height: 12),
                  _ChecklistCompletionSummary(
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
                  const SizedBox(height: 96),
                ],
              ),
              IpalFloatingScrollControls(controller: _scrollController),
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
    final normalizedProcessDraft = processDraft.copyWith(
      tanggal: checklistDraft.tanggal,
    );

    if (normalizedProcessDraft.tanggal != checklistDraft.tanggal) {
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
        processDraft: normalizedProcessDraft,
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
      _fieldRevision++;
    });
    _showMessage('Draft checklist lokal dihapus.');
  }

  IpalChecklistDraft _draftFor(IpalChecklistTemplate template) {
    return IpalChecklistDraft(
      tanggal: _todayLabel,
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

class _ChecklistCompletionSummary extends StatelessWidget {
  const _ChecklistCompletionSummary({
    required this.items,
    required this.statuses,
  });

  final List<IpalChecklistItem> items;
  final Map<String, String> statuses;

  @override
  Widget build(BuildContext context) {
    final completed = items
        .where((item) => (statuses[item.id.toString()] ?? '').isNotEmpty)
        .length;
    final total = items.length;
    final missing = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;
    final isComplete = total > 0 && missing == 0;
    final color = isComplete ? Colors.green : Colors.red;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCompletionSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(
                  isComplete ? Icons.check_circle_outline : Icons.error_outline,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelengkapan Checklist',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.red.withValues(alpha: 0.14),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$completed/$total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    missing == 0 ? 'Lengkap' : '$missing kosong',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: color),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletionSheet(BuildContext context) {
    final completedItems = items
        .where((item) => (statuses[item.id.toString()] ?? '').isNotEmpty)
        .toList(growable: false);
    final missingItems = items
        .where((item) => (statuses[item.id.toString()] ?? '').isEmpty)
        .toList(growable: false);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            children: [
              Text(
                'Detail Kelengkapan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _CompletionList(
                title: 'Belum diisi',
                color: Colors.red,
                icon: Icons.error_outline,
                items: missingItems,
                emptyText: 'Semua item sudah diisi.',
              ),
              const SizedBox(height: 14),
              _CompletionList(
                title: 'Sudah diisi',
                color: Colors.green,
                icon: Icons.check_circle_outline,
                items: completedItems,
                emptyText: 'Belum ada item yang diisi.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompletionList extends StatelessWidget {
  const _CompletionList({
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title (${items.length})',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(emptyText, style: Theme.of(context).textTheme.bodySmall)
            else
              for (final item in items)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(icon, color: color),
                  title: Text(item.name),
                ),
          ],
        ),
      ),
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
            _ChecklistStatusToggle(value: status, onChanged: onStatusChanged),
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

class _ChecklistStatusToggle extends StatelessWidget {
  const _ChecklistStatusToggle({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return IpalValueToggle(
      value: value,
      options: const [
        IpalToggleOption(
          value: 'OK',
          label: 'Ya',
          icon: Icons.check,
          color: Colors.green,
        ),
        IpalToggleOption(
          value: 'NOT_OK',
          label: 'Tidak',
          icon: Icons.close,
          color: Colors.red,
        ),
      ],
      onChanged: onChanged,
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
