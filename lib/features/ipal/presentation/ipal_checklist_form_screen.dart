import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../core/files/upload_image_optimizer.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../../../shared/widgets/hse_confirm_dialog.dart';
import '../application/ipal_checklist_master_controller.dart';
import '../application/ipal_log_controller.dart';
import '../data/ipal_checklist_repository_impl.dart';
import '../domain/entities/ipal_checklist_draft.dart';
import '../domain/entities/ipal_checklist_master.dart';
import '../domain/services/ipal_checklist_payload_builder.dart';
import 'widgets/ipal_android_scrollbar.dart';
import 'widgets/ipal_floating_scroll_controls.dart';
import 'widgets/ipal_form_tabs.dart';
import 'widgets/ipal_today_log_guard.dart';
import 'widgets/ipal_value_toggle.dart';

class IpalChecklistFormScreen extends ConsumerStatefulWidget {
  const IpalChecklistFormScreen({this.queueItemId, super.key});

  final String? queueItemId;

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
  String? _loadedDateLabel;
  bool _saving = false;
  int _fieldRevision = 0;
  late final SubmitQueueService _queueService;

  bool get _isQueueEdit => widget.queueItemId?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    _queueService = ref.read(submitQueueServiceProvider);

    final queueItemId = widget.queueItemId;
    if (queueItemId != null) {
      unawaited(_prepareQueueEdit(queueItemId));
    }
  }

  @override
  void dispose() {
    final queueItemId = widget.queueItemId;
    if (queueItemId != null) {
      unawaited(_queueService.unlockItem(queueItemId));
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templatesState = ref.watch(ipalChecklistTemplatesProvider);
    final selectedDate = ref.watch(ipalSelectedDateProvider);
    final selectedDateLabel = _dateFormat.format(selectedDate);
    final existingLog = _isQueueEdit
        ? null
        : ref.watch(ipalTodayLogProvider).value;
    final existingLogId = _intValue(existingLog?['id']);
    final existingDetailState = existingLogId == null
        ? null
        : ref.watch(ipalLogDetailProvider(existingLogId));

    return HseAppScaffold(
      title: _isQueueEdit ? 'Edit Antrean IPAL' : 'Form IPAL',
      selectedPath: _isQueueEdit ? '/antrean-submit' : '/form/ipal/checklist',
      showBackButton: true,
      body: _guardedBody(
        templatesState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorState(
            message: 'Master checklist belum bisa dimuat: $error',
            onRetry: () => ref.invalidate(ipalChecklistTemplatesProvider),
          ),
          data: (templates) {
            if (existingLogId != null &&
                existingDetailState?.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }
            if (existingLogId != null &&
                existingDetailState?.hasError == true) {
              return _ErrorState(
                message: 'Draft IPAL existing belum bisa dimuat.',
                onRetry: () =>
                    ref.invalidate(ipalLogDetailProvider(existingLogId)),
              );
            }

            _loadDraftOnce(
              templates,
              existingLog: _detailData(existingDetailState?.value),
            );
            final template = _selectedTemplate(templates);
            if (template == null) return const _EmptyChecklistState();

            final activeItems = template.items
                .where((item) => item.isActive)
                .toList(growable: false);
            final groupedItems = _groupItems(activeItems);

            return _buildResponsiveForm(
              template: template,
              activeItems: activeItems,
              groupedItems: groupedItems,
              selectedDateLabel: selectedDateLabel,
            );
          },
        ),
      ),
    );
  }

  Future<void> _prepareQueueEdit(String queueItemId) async {
    final item = _queueService.findById(queueItemId);
    final date = DateTime.tryParse(item?.payload['tanggal']?.toString() ?? '');
    if (date != null) {
      ref.read(ipalSelectedDateProvider.notifier).set(date);
    }
    await _queueService.lockItem(queueItemId);
  }

  Widget _guardedBody(Widget child) {
    if (_isQueueEdit) return child;

    return IpalTodayLogGuard(child: child);
  }

  Widget _buildResponsiveForm({
    required IpalChecklistTemplate template,
    required List<IpalChecklistItem> activeItems,
    required Map<String, List<IpalChecklistItem>> groupedItems,
    required String selectedDateLabel,
  }) {
    final summary = _ChecklistCompletionSummary(
      items: activeItems,
      statuses: _statuses,
    );
    final actions = _ActionBar(
      queueEdit: _isQueueEdit,
      saving: _saving,
      onSaveDraft: () =>
          _isQueueEdit ? _saveQueue(template) : _saveDraft(template),
      onReset: _confirmResetDraft,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout = constraints.maxWidth >= 900;
        final useTwoColumns = constraints.maxWidth >= 1180;

        if (!useWideLayout) {
          return Stack(
            children: [
              IpalAndroidScrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (!_isQueueEdit) ...[
                      const IpalFormTabs(selected: IpalFormTab.checklist),
                      const SizedBox(height: 16),
                    ],
                    _FormTitleCard(
                      title: 'Checklist Harian',
                      icon: Icons.checklist_outlined,
                      subtitle: selectedDateLabel,
                    ),
                    const SizedBox(height: 12),
                    _OperationalDateCard(
                      label: selectedDateLabel,
                      onPressed: _pickOperationalDate,
                    ),
                    const SizedBox(height: 12),
                    if (_isQueueEdit) ...[
                      const _QueueEditNotice(moduleLabel: 'Checklist IPAL'),
                      const SizedBox(height: 12),
                    ],
                    summary,
                    const SizedBox(height: 16),
                    ..._checklistCards(groupedItems),
                    const SizedBox(height: 8),
                    actions,
                    const SizedBox(height: 96),
                  ],
                ),
              ),
              if (constraints.maxWidth >= 600)
                IpalFloatingScrollControls(controller: _scrollController),
            ],
          );
        }

        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 330,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                    children: [
                      if (!_isQueueEdit) ...[
                        const IpalFormTabs(selected: IpalFormTab.checklist),
                        const SizedBox(height: 16),
                      ],
                      _FormTitleCard(
                        title: 'Checklist Harian',
                        icon: Icons.checklist_outlined,
                        subtitle: selectedDateLabel,
                      ),
                      const SizedBox(height: 12),
                      _OperationalDateCard(
                        label: selectedDateLabel,
                        onPressed: _pickOperationalDate,
                      ),
                      const SizedBox(height: 12),
                      if (_isQueueEdit) ...[
                        const _QueueEditNotice(moduleLabel: 'Checklist IPAL'),
                        const SizedBox(height: 12),
                      ],
                      summary,
                      const SizedBox(height: 16),
                      actions,
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IpalAndroidScrollbar(
                    controller: _scrollController,
                    alwaysVisible: true,
                    child: ListView(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(16, 16, 24, 96),
                      children: [
                        if (useTwoColumns)
                          _ChecklistTwoColumnGrid(
                            entries: groupedItems.entries.toList(
                              growable: false,
                            ),
                            fieldRevision: _fieldRevision,
                            statuses: _statuses,
                            notes: _notes,
                            attachmentPaths: _attachmentPaths,
                            onStatusChanged: _setStatus,
                            onNoteChanged: _setNote,
                            onPickAttachment: _pickAttachment,
                            onRemoveAttachment: _removeAttachment,
                          )
                        else
                          ..._checklistCards(groupedItems),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            IpalFloatingScrollControls(controller: _scrollController),
          ],
        );
      },
    );
  }

  List<Widget> _checklistCards(
    Map<String, List<IpalChecklistItem>> groupedItems,
  ) {
    return [
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
    ];
  }

  void _loadDraftOnce(
    List<IpalChecklistTemplate> templates, {
    Map<String, dynamic>? existingLog,
  }) {
    final dateLabel = _selectedDateLabel;
    if (_draftLoaded && _loadedDateLabel == dateLabel) return;
    _draftLoaded = true;
    _loadedDateLabel = dateLabel;
    _statuses.clear();
    _notes.clear();
    _attachmentPaths.clear();

    if (_isQueueEdit) {
      _applyQueuePayload();
      _fieldRevision++;
      return;
    }

    _applyExistingLog(existingLog);

    final draft = ref.read(ipalChecklistRepositoryProvider).readDraft();
    if (draft == null || draft.tanggal != dateLabel) {
      _selectedTemplateId ??= templates.firstOrNull?.id;
      _fieldRevision++;
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
      imageQuality: UploadImageOptimizer.pickerImageQuality,
      maxWidth: UploadImageOptimizer.pickerMaxDimension,
      maxHeight: UploadImageOptimizer.pickerMaxDimension,
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

  Future<void> _saveQueue(IpalChecklistTemplate template) async {
    final queueItemId = widget.queueItemId;
    if (queueItemId == null) return;

    setState(() => _saving = true);
    final service = ref.read(submitQueueServiceProvider);
    final item = service.findById(queueItemId);
    if (item == null) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showMessage('Antrean IPAL tidak ditemukan.');
      return;
    }

    final dateLabel = _selectedDateLabel;
    final payload = Map<String, dynamic>.from(item.payload)
      ..['tanggal'] = dateLabel
      ..['checklist'] = IpalChecklistPayloadBuilder.buildChecklistPayload(
        template: template,
        draft: _draftFor(template),
      );

    await service.updatePayload(
      queueItemId,
      payload,
      moduleLabel: 'Log IPAL',
      displayDate: dateLabel,
    );
    if (!mounted) return;

    setState(() => _saving = false);
    _showMessage('Antrean checklist IPAL diperbarui.');
    context.pop();
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

  Future<void> _confirmResetDraft() async {
    final confirmed = await showHseConfirmDialog(
      context: context,
      title: 'Reset Draft Checklist',
      message: 'Draft checklist lokal akan dihapus dari perangkat ini.',
      confirmLabel: 'Reset',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    await _resetDraft();
  }

  IpalChecklistDraft _draftFor(IpalChecklistTemplate template) {
    return IpalChecklistDraft(
      tanggal: _selectedDateLabel,
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

  String get _selectedDateLabel =>
      _dateFormat.format(ref.read(ipalSelectedDateProvider));

  Future<void> _pickOperationalDate() async {
    final current = ref.read(ipalSelectedDateProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;

    ref.read(ipalSelectedDateProvider.notifier).set(picked);
    ref.invalidate(ipalTodayLogProvider);
    ref.invalidate(ipalProcessReferencesProvider);
  }

  void _applyExistingLog(Map<String, dynamic>? existingLog) {
    final checklist = _mapValue(existingLog?['checklist']);
    if (checklist == null) return;

    _selectedTemplateId = _intValue(checklist['template_id']);
    final values = checklist['values'];
    if (values is! Iterable) return;

    for (final value in values) {
      final valueMap = _mapValue(value);
      if (valueMap == null) continue;
      final key = valueMap['item_id']?.toString();
      if (key == null || key.isEmpty) continue;

      final status = valueMap['status']?.toString() ?? '';
      if (status.isNotEmpty) {
        _statuses[key] = status;
      }

      final note = valueMap['note']?.toString();
      if (note != null && note.isNotEmpty) {
        _notes[key] = note;
      }
    }
  }

  void _applyQueuePayload() {
    final queueItemId = widget.queueItemId;
    if (queueItemId == null) return;

    final item = ref.read(submitQueueServiceProvider).findById(queueItemId);
    final checklist = _mapValue(item?.payload['checklist']);
    if (checklist == null) return;

    _selectedTemplateId = _intValue(checklist['template_id']);
    final values = checklist['values'];
    if (values is! Iterable) return;

    for (final value in values) {
      final valueMap = _mapValue(value);
      if (valueMap == null) continue;
      final key = valueMap['item_id']?.toString();
      if (key == null || key.isEmpty) continue;

      final status = valueMap['status']?.toString() ?? '';
      if (status.isNotEmpty) {
        _statuses[key] = status;
      }

      final note = valueMap['note']?.toString();
      if (note != null && note.isNotEmpty) {
        _notes[key] = note;
      }

      final attachmentPath = valueMap['attachment_path']?.toString();
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        _attachmentPaths[key] = attachmentPath;
      }
    }
  }
}

class _FormTitleCard extends StatelessWidget {
  const _FormTitleCard({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  final String title;
  final IconData icon;
  final String subtitle;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Tanggal IPAL $subtitle',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OperationalDateCard extends StatelessWidget {
  const _OperationalDateCard({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          final content = Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.primaryPastel,
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Operasional',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          );

          return Padding(
            padding: const EdgeInsets.all(14),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      content,
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: onPressed,
                        icon: const Icon(Icons.edit_calendar_outlined),
                        label: const Text('Ubah Tanggal'),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: content),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 112,
                        child: OutlinedButton.icon(
                          onPressed: onPressed,
                          icon: const Icon(Icons.edit_calendar_outlined),
                          label: const Text('Ubah'),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _QueueEditNotice extends StatelessWidget {
  const _QueueEditNotice({required this.moduleLabel});

  final String moduleLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.infoPastel,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_queue_outlined, color: AppColors.info),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Anda sedang mengedit $moduleLabel yang masih menunggu koneksi. Perubahan disimpan kembali ke antrean, belum ke server.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, dynamic>? _detailData(Map<String, dynamic>? response) {
  final data = response?['data'];
  return _mapValue(data);
}

Map<String, dynamic>? _mapValue(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
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

class _ChecklistTwoColumnGrid extends StatelessWidget {
  const _ChecklistTwoColumnGrid({
    required this.entries,
    required this.fieldRevision,
    required this.statuses,
    required this.notes,
    required this.attachmentPaths,
    required this.onStatusChanged,
    required this.onNoteChanged,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
  });

  final List<MapEntry<String, List<IpalChecklistItem>>> entries;
  final int fieldRevision;
  final Map<String, String> statuses;
  final Map<String, String> notes;
  final Map<String, String> attachmentPaths;
  final void Function(int itemId, String value) onStatusChanged;
  final void Function(int itemId, String value) onNoteChanged;
  final Future<void> Function(int itemId, ImageSource source) onPickAttachment;
  final void Function(int itemId) onRemoveAttachment;

  @override
  Widget build(BuildContext context) {
    final columns = [
      <MapEntry<String, List<IpalChecklistItem>>>[],
      <MapEntry<String, List<IpalChecklistItem>>>[],
    ];
    for (var index = 0; index < entries.length; index++) {
      columns[index.isEven ? 0 : 1].add(entries[index]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var columnIndex = 0; columnIndex < columns.length; columnIndex++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: columnIndex == 0 ? 0 : 12),
              child: Column(
                children: [
                  for (final entry in columns[columnIndex]) ...[
                    _ChecklistCategoryCard(
                      key: ValueKey('wide_${entry.key}_$fieldRevision'),
                      category: entry.key,
                      items: entry.value,
                      statuses: statuses,
                      notes: notes,
                      attachmentPaths: attachmentPaths,
                      onStatusChanged: onStatusChanged,
                      onNoteChanged: onNoteChanged,
                      onPickAttachment: onPickAttachment,
                      onRemoveAttachment: onRemoveAttachment,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
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
    required this.queueEdit,
    required this.saving,
    required this.onSaveDraft,
    required this.onReset,
  });

  final bool queueEdit;
  final bool saving;
  final VoidCallback onSaveDraft;
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
          label: Text(
            queueEdit ? 'Simpan Perubahan Antrean' : 'Simpan Draft Checklist',
          ),
        ),
        if (!queueEdit) ...[
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: saving ? null : onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Draft Checklist'),
          ),
        ],
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
