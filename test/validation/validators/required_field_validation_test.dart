import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value == null || value.isEmpty ? 'Required.' : null;
  }
}

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Required.');
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), 'Required.');
  });
}