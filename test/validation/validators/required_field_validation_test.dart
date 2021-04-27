import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Required');
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), 'Required');
  });
}