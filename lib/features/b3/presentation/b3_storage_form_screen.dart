import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../color_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/submit_queue_service.dart';
import '../../../shared/layout/hse_app_scaffold.dart';
import '../application/b3_master_controller.dart';
import '../data/b3_storage_repository.dart';
import '../domain/entities/b3_master_data.dart';
import '../domain/entities/b3_storage_draft.dart';
import '../domain/services/b3_storage_payload_builder.dart';

class B3StorageFormScreen extends ConsumerStatefulWidget {
  const B3StorageFormScreen({super.key});

  @override
  ConsumerState<B3StorageFormScreen> createState() =>
      _B3StorageFormScreenState();
}

class _B3StorageFormScreenState extends ConsumerState<B3StorageFormScreen> {
  static const _otherValue = -1;

  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm');
  final _weightController = TextEditingController();
  final _documentController = TextEditingController();
  final _wasteOtherController = TextEditingController();
  final _departmentOtherController = TextEditingController();
  final _noteController = TextEditingController();
  final _imagePicker = ImagePicker();

  DateTime _movementDate = DateTime.now();
  TimeOfDay _movementTime = TimeOfDay.now();
  String _movementType = 'MASUK';
  int? _wasteTypeId;
  int? _departmentId;
  String? _photoPath;
  bool _draftLoaded = false;
  bool _saving = false;
  bool _submitting = false;

  @override
  void dispose() {
    _weightController.dispose();
    _documentController.dispose();
    _wasteOtherController.dispose();
    _departmentOtherController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final masterState = ref.watch(b3MasterProvider);

    return HseAppScaffold(
      title: 'Penyimpanan Limbah B3',
      selectedPath: '/form/b3',
      showBackButton: true,
      body: masterState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'Master B3 belum bisa dimuat: $error',
          onRetry: () => ref.invalidate(b3MasterProvider),
        ),
        data: (master) {
          _loadDraftOnce();
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _MovementCard(
                  dateLabel: _dateFormat.format(_movementDate),
                  timeLabel: _formatTime(_movementTime),
                  movementType: _movementType,
                  onPickDate: _pickDate,
                  onPickTime: _pickTime,
                  onMovementTypeChanged: (value) {
                    if (value != null) setState(() => _movementType = value);
                  },
                ),
                const SizedBox(height: 12),
                _WasteCard(
                  wasteTypes: master.wasteTypes,
                  departments: master.departments,
                  wasteTypeId: _wasteTypeId,
                  departmentId: _departmentId,
                  wasteOtherController: _wasteOtherController,
                  departmentOtherController: _departmentOtherController,
                  weightController: _weightController,
                  documentController: _documentController,
                  noteController: _noteController,
                  onWasteChanged: (value) =>
                      setState(() => _wasteTypeId = value),
                  onDepartmentChanged: (value) =>
                      setState(() => _departmentId = value),
                ),
                const SizedBox(height: 12),
                _PhotoCard(
                  photoPath: _photoPath,
                  onPickGallery: () => _pickPhoto(ImageSource.gallery),
                  onPickCamera: () => _pickPhoto(ImageSource.camera),
                  onRemove: () => setState(() => _photoPath = null),
                ),
                const SizedBox(height: 20),
                _ActionBar(
                  saving: _saving,
                  submitting: _submitting,
                  onSaveDraft: _saveDraft,
                  onSubmit: _submit,
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

  void _loadDraftOnce() {
    if (_draftLoaded) return;
    _draftLoaded = true;
    final draft = ref.read(b3StorageRepositoryProvider).readDraft();
    if (draft == null) return;

    _movementDate = DateTime.tryParse(draft.movementDate) ?? DateTime.now();
    _movementTime = _parseTime(draft.movementTime);
    _movementType = draft.movementType;
    _wasteTypeId =
        draft.wasteTypeId ??
        (draft.wasteTypeOther == null ? null : _otherValue);
    _departmentId =
        draft.initiatorDepartmentId ??
        (draft.initiatorDepartmentOther == null ? null : _otherValue);
    _wasteOtherController.text = draft.wasteTypeOther ?? '';
    _departmentOtherController.text = draft.initiatorDepartmentOther ?? '';
    _weightController.text = draft.weightKg ?? '';
    _documentController.text = draft.documentNumber ?? '';
    _noteController.text = draft.note ?? '';
    _photoPath = draft.photoPath;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _movementDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked == null) return;
    setState(() => _movementDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _movementTime,
    );
    if (picked == null) return;
    setState(() => _movementTime = picked);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1600,
    );
    if (image == null) return;
    setState(() => _photoPath = image.path);
  }

  Future<void> _saveDraft() async {
    setState(() => _saving = true);
    await ref.read(b3StorageRepositoryProvider).saveDraft(_draft());
    if (!mounted) return;
    setState(() => _saving = false);
    _showMessage('Draft B3 berhasil disimpan.');
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final draft = _draft();
    final errors = B3StoragePayloadBuilder.validate(draft);
    if (errors.isNotEmpty) {
      _showMessage(errors.first);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(b3StorageRepositoryProvider).createLog(draft);
      await ref.read(b3StorageRepositoryProvider).clearDraft();
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _weightController.clear();
        _documentController.clear();
        _wasteOtherController.clear();
        _departmentOtherController.clear();
        _noteController.clear();
        _wasteTypeId = null;
        _departmentId = null;
        _photoPath = null;
      });
      _showMessage('Log penyimpanan limbah B3 berhasil dikirim.');
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      if (_canQueue(error)) {
        await _enqueueB3Log(draft);
        _showMessage(
          'Koneksi belum stabil. Draft B3 disimpan ke antrean submit.',
        );
        return;
      }
      _showMessage(error.message);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showMessage('Log B3 gagal dikirim: $error');
    }
  }

  Future<void> _resetDraft() async {
    await ref.read(b3StorageRepositoryProvider).clearDraft();
    setState(() {
      _movementDate = DateTime.now();
      _movementTime = TimeOfDay.now();
      _movementType = 'MASUK';
      _wasteTypeId = null;
      _departmentId = null;
      _photoPath = null;
      _weightController.clear();
      _documentController.clear();
      _wasteOtherController.clear();
      _departmentOtherController.clear();
      _noteController.clear();
    });
    _showMessage('Draft B3 lokal dihapus.');
  }

  B3StorageDraft _draft() {
    return B3StorageDraft(
      movementDate: _dateFormat.format(_movementDate),
      movementTime: _formatTime(_movementTime),
      movementType: _movementType,
      wasteTypeId: _wasteTypeId == _otherValue ? null : _wasteTypeId,
      wasteTypeOther: _wasteTypeId == _otherValue
          ? _wasteOtherController.text.trim()
          : null,
      initiatorDepartmentId: _departmentId == _otherValue
          ? null
          : _departmentId,
      initiatorDepartmentOther: _departmentId == _otherValue
          ? _departmentOtherController.text.trim()
          : null,
      weightKg: _weightController.text.trim(),
      documentNumber: _documentController.text.trim(),
      photoPath: _photoPath,
      note: _noteController.text.trim(),
    );
  }

  String _formatTime(TimeOfDay time) {
    final date = DateTime(2026, 1, 1, time.hour, time.minute);
    return _timeFormat.format(date);
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return TimeOfDay.now();
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? TimeOfDay.now().hour,
      minute: int.tryParse(parts[1]) ?? TimeOfDay.now().minute,
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

  Future<void> _enqueueB3Log(B3StorageDraft draft) {
    return ref
        .read(submitQueueServiceProvider)
        .enqueue(
          SubmitQueueItem(
            id: 'b3-${DateTime.now().microsecondsSinceEpoch}',
            endpoint: '/b3-storage/logs',
            method: 'POST',
            payload: draft.toJson(),
            createdAt: DateTime.now(),
          ),
        );
  }
}

class _MovementCard extends StatelessWidget {
  const _MovementCard({
    required this.dateLabel,
    required this.timeLabel,
    required this.movementType,
    required this.onPickDate,
    required this.onPickTime,
    required this.onMovementTypeChanged,
  });

  final String dateLabel;
  final String timeLabel;
  final String movementType;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final ValueChanged<String?> onMovementTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Pergerakan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(dateLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickTime,
                    icon: const Icon(Icons.schedule),
                    label: Text(timeLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: movementType,
              decoration: const InputDecoration(
                labelText: 'Jenis Pergerakan',
                prefixIcon: Icon(Icons.compare_arrows),
              ),
              items: const [
                DropdownMenuItem(value: 'MASUK', child: Text('Masuk')),
                DropdownMenuItem(value: 'KELUAR', child: Text('Keluar')),
              ],
              onChanged: onMovementTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _WasteCard extends StatelessWidget {
  const _WasteCard({
    required this.wasteTypes,
    required this.departments,
    required this.wasteTypeId,
    required this.departmentId,
    required this.wasteOtherController,
    required this.departmentOtherController,
    required this.weightController,
    required this.documentController,
    required this.noteController,
    required this.onWasteChanged,
    required this.onDepartmentChanged,
  });

  final List<B3MasterOption> wasteTypes;
  final List<B3MasterOption> departments;
  final int? wasteTypeId;
  final int? departmentId;
  final TextEditingController wasteOtherController;
  final TextEditingController departmentOtherController;
  final TextEditingController weightController;
  final TextEditingController documentController;
  final TextEditingController noteController;
  final ValueChanged<int?> onWasteChanged;
  final ValueChanged<int?> onDepartmentChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Limbah',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            _MasterDropdown(
              label: 'Jenis Limbah',
              value: wasteTypeId,
              options: wasteTypes,
              onChanged: onWasteChanged,
            ),
            if (wasteTypeId == _B3StorageFormScreenState._otherValue) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: wasteOtherController,
                decoration: const InputDecoration(
                  labelText: 'Jenis limbah lainnya',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jenis limbah lainnya wajib diisi.';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 12),
            _MasterDropdown(
              label: 'Dept Inisiator',
              value: departmentId,
              options: departments,
              onChanged: onDepartmentChanged,
            ),
            if (departmentId == _B3StorageFormScreenState._otherValue) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: departmentOtherController,
                decoration: const InputDecoration(
                  labelText: 'Dept inisiator lainnya',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Dept inisiator lainnya wajib diisi.';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Berat Limbah (kg)',
                prefixIcon: Icon(Icons.scale_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Berat limbah wajib diisi.';
                }
                if (num.tryParse(value.trim()) == null) {
                  return 'Berat limbah harus angka.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: documentController,
              decoration: const InputDecoration(
                labelText: 'Nomor Dokumen',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nomor dokumen wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteController,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan opsional',
                prefixIcon: Icon(Icons.comment_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MasterDropdown extends StatelessWidget {
  const _MasterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final List<B3MasterOption> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.list_alt_outlined),
      ),
      items: [
        for (final option in options.where((option) => option.isActive))
          DropdownMenuItem(value: option.id, child: Text(option.name)),
        const DropdownMenuItem(
          value: _B3StorageFormScreenState._otherValue,
          child: Text('Yang lain'),
        ),
      ],
      validator: (value) {
        if (value == null) return '$label wajib dipilih.';
        return null;
      },
      onChanged: onChanged,
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.photoPath,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  final String? photoPath;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foto Serah Terima',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Maksimum 5 MB sesuai validasi backend.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (photoPath?.isNotEmpty == true)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Foto dipilih'),
                  subtitle: Text(
                    photoPath!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    tooltip: 'Hapus Foto',
                    icon: const Icon(Icons.close),
                    onPressed: onRemove,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galeri'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPickCamera,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Kamera'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.saving,
    required this.submitting,
    required this.onSaveDraft,
    required this.onSubmit,
    required this.onReset,
  });

  final bool saving;
  final bool submitting;
  final VoidCallback onSaveDraft;
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
          label: const Text('Simpan Draft B3'),
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
          label: const Text('Submit Log B3'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: submitting ? null : onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Draft B3'),
        ),
      ],
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
