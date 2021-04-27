import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';
import 'package:fordev/main/factories/pages/pages.dart';

void main() {
  test('Should return correct validations', () {
    expect(createLoginValidationsList(), [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}