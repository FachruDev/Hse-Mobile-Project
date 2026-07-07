import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';

void main() {
  test('HseInputType parse mengikuti input_type dari master data', () {
    expect(HseInputType.parse('number'), HseInputType.number);
    expect(HseInputType.parse('select'), HseInputType.dropdown);
    expect(HseInputType.parse('option_standard'), HseInputType.optionStandard);
    expect(
      HseInputType.parse('option_with_manual'),
      HseInputType.optionWithManual,
    );
    expect(HseInputType.parse('status'), HseInputType.checklist);
    expect(HseInputType.parse('tidak dikenal'), HseInputType.text);
  });
}
