import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_master.dart';

void main() {
  test('fromApiJson menerima inputtype dari API backend', () {
    final master = IpalProcessMaster.fromApiJson({
      'templates': [
        {
          'id': '1',
          'name': 'Catatan Proses IPAL',
          'sections': [
            {
              'id': 10,
              'name': 'Penampungan Awal',
              'items': [
                {
                  'id': 100,
                  'name': 'Debit inlet',
                  'code': 'debit_inlet_flow_meter',
                  'inputtype': 'number',
                  'standard_condition': 'Terukur',
                },
              ],
            },
          ],
        },
      ],
      'batch_sections': [
        {
          'id': 1,
          'name': 'Air limbah awal',
          'order_no': '1',
          'items': [
            {
              'id': 1,
              'name': 'pH',
              'inputtype': 'option_standard',
              'order_no': '1',
              'options': ['Asam', 'Netral', 'Basa'],
            },
          ],
        },
      ],
    });

    final processItem = master.templates.single.sections.single.items.single;
    final batchSection = master.batchSections.single;
    final batchItem = batchSection.items.single;

    expect(master.templates.single.id, 1);
    expect(processItem.label, 'Debit inlet');
    expect(processItem.code, 'debit_inlet_flow_meter');
    expect(processItem.standard, 'Terukur');
    expect(processItem.inputType, HseInputType.number);
    expect(batchSection.name, 'Air limbah awal');
    expect(batchSection.orderNo, 1);
    expect(batchItem.inputType, HseInputType.optionStandard);
    expect(batchItem.options.map((option) => option.value), [
      'Asam',
      'Netral',
      'Basa',
    ]);
  });
}
