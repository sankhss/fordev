import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    final isValid = value == null || value.isEmpty || regex.hasMatch(value);
    return isValid ? null : 'This is not a valid email.';
  }
}

void main() {
  EmailValidation sut;
  String email;

  setUp((){
    sut = EmailValidation('any');
    email = faker.internet.email();
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate(email), null);
  });
}