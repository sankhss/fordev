import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/validation.dart';

class ValidationSpy extends Mock implements Validation {}

main() {
  GetxSignUpPresenter sut;
  Validation validation;
  String email;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String field, ValidationError result}) =>
      mockValidationCall(field).thenReturn(result);

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();

    mockValidation();
  });

  group('validation', () {
    test('Should call email Validation', () {
      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit error if email is invalid', () {
      mockValidation(result: ValidationError.invalidEmail);

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidEmail)));
      sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit error if email is empty', () {
      mockValidation(result: ValidationError.requiredField);

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit null if email validation succeed', () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });
}
