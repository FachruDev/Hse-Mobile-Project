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
                  'label': 'Debit inlet',
                  'inputtype': 'number',
                  'standard': 'Terukur',
                },
              ],
            },
          ],
        },
      ],
      'batch_items': [
        {'id': 1, 'label': 'pH', 'inputtype': 'number', 'order_no': '1'},
      ],
    });

    expect(master.templates.single.id, 1);
    expect(
      master.templates.single.sections.single.items.single.inputType,
      HseInputType.number,
    );
    expect(master.batchItems.single.orderNo, 1);
  });
}
