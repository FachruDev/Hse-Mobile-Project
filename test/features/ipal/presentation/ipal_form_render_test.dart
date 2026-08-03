import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/core/storage/submit_queue_service.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';
import 'package:hse_mobile/features/ipal/application/ipal_checklist_master_controller.dart';
import 'package:hse_mobile/features/ipal/application/ipal_log_controller.dart';
import 'package:hse_mobile/features/ipal/application/ipal_process_master_controller.dart';
import 'package:hse_mobile/features/ipal/data/ipal_checklist_repository_impl.dart';
import 'package:hse_mobile/features/ipal/data/ipal_process_repository_impl.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_master.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_master.dart';
import 'package:hse_mobile/features/ipal/domain/repositories/ipal_checklist_repository.dart';
import 'package:hse_mobile/features/ipal/domain/repositories/ipal_process_repository.dart';
import 'package:hse_mobile/features/ipal/presentation/ipal_checklist_form_screen.dart';
import 'package:hse_mobile/features/ipal/presentation/ipal_process_form_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('checklist IPAL renders on phone and tablet', (tester) async {
    await _setSurfaceSize(tester, const Size(390, 844));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._baseOverrides,
          ipalChecklistTemplatesProvider.overrideWith(
            (ref) async => _checklistTemplates,
          ),
          ipalChecklistRepositoryProvider.overrideWithValue(
            _FakeChecklistRepository(_checklistTemplates),
          ),
        ],
        child: _materialApp(const IpalChecklistFormScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Tanggal Operasional'), findsOneWidget);
    expect(find.text('Checklist Harian'), findsWidgets);

    await _setSurfaceSize(tester, const Size(1024, 768));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Tanggal Operasional'), findsOneWidget);
  });

  testWidgets('proses IPAL renders on phone and tablet', (tester) async {
    await _setSurfaceSize(tester, const Size(390, 844));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._baseOverrides,
          ipalProcessMasterProvider.overrideWith((ref) async => _processMaster),
          ipalProcessRepositoryProvider.overrideWithValue(
            _FakeProcessRepository(_processMaster),
          ),
          ipalChecklistRepositoryProvider.overrideWithValue(
            _FakeChecklistRepository(_checklistTemplates),
          ),
        ],
        child: _materialApp(const IpalProcessFormScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Tanggal Operasional'), findsOneWidget);
    expect(find.text('Catatan Proses IPAL'), findsWidgets);

    await _setSurfaceSize(tester, const Size(1024, 768));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Tanggal Operasional'), findsOneWidget);
  });
}

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.binding.setSurfaceSize(null);
  });
}

Widget _materialApp(Widget child) {
  return MaterialApp(
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.4)),
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: child,
  );
}

final _baseOverrides = [
  submitQueueItemsProvider.overrideWith((ref) => Stream.value(const [])),
  ipalTodayLogProvider.overrideWith((ref) async => null),
  ipalProcessReferencesProvider.overrideWith(
    (ref) async => const <String, IpalProcessReference>{},
  ),
];

final _checklistTemplates = [
  const IpalChecklistTemplate(
    id: 1,
    name: 'Checklist Harian',
    items: [
      IpalChecklistItem(
        id: 10,
        name: 'Pompa inlet',
        category: 'Peralatan',
        standardCondition: 'Normal',
      ),
    ],
  ),
];

const _processMaster = IpalProcessMaster(
  templates: [
    IpalProcessTemplate(
      id: 1,
      name: 'Catatan Proses IPAL',
      sections: [
        IpalProcessSection(
          id: 1,
          name: 'Bak Inlet',
          items: [
            IpalProcessItem(
              id: 101,
              label: 'Debit inlet',
              inputType: HseInputType.optionWithIntegerM3,
              code: 'debit_inlet_flow_meter',
              standard: 'Standar',
            ),
          ],
        ),
      ],
    ),
  ],
  batchSections: [
    IpalProcessSection(
      id: 2,
      name: 'Batch Mixing',
      items: [
        IpalProcessItem(
          id: 201,
          label: 'pH awal',
          inputType: HseInputType.decimal2,
          standard: '6-9',
        ),
      ],
    ),
  ],
);

class _FakeChecklistRepository implements IpalChecklistRepository {
  const _FakeChecklistRepository(this.templates);

  final List<IpalChecklistTemplate> templates;

  @override
  Future<List<IpalChecklistTemplate>> getChecklistTemplates() async {
    return templates;
  }

  @override
  IpalChecklistDraft? readDraft() => null;

  @override
  Future<void> saveDraft(IpalChecklistDraft draft) async {}

  @override
  Future<void> clearDraft() async {}
}

class _FakeProcessRepository implements IpalProcessRepository {
  const _FakeProcessRepository(this.master);

  final IpalProcessMaster master;

  @override
  Future<IpalProcessMaster> getProcessMaster({
    bool forceRefresh = false,
  }) async {
    return master;
  }

  @override
  IpalProcessDraft? readDraft() => null;

  @override
  Future<void> saveDraft(IpalProcessDraft draft) async {}

  @override
  Future<void> clearDraft() async {}
}
