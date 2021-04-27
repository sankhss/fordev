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
    return null;
  }
}

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation('field');

    expect(sut.validate('value'), null);
  });

  test('Should return error if value is empty', () {
    final sut = RequiredFieldValidation('field');

    expect(sut.validate(''), 'Required.');
  });
}