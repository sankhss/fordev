import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp((){
    sut = EmailValidation('any');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate(faker.internet.email()), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('invalid'), 'This is not a valid email.');
  });
}