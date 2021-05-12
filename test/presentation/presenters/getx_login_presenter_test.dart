import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

main() {
  GetxLoginPresenter sut;
  Validation validation;
  Authentication authentication;
  SaveCurrentAccount saveCurrentAccount;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String field, ValidationError result}) =>
      mockValidationCall(field).thenReturn(result);

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));

  void mockAuthentication() => mockAuthenticationCall().thenAnswer((_) async => Account(token));

  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);

  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

  void validateForm() {
    sut.validateEmail(email);
    sut.validatePassword(password);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAuthentication();
  });

  group('validation', () {
    test('Should call email validation', () {
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

    test('Should call password validation', () {
      sut.validatePassword(password);

      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit error if password validation fails', () {
    mockValidation(result: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

    test('Should emit null if password validation succeed', () {
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit error if any validation fails', () {
    mockValidation(field: 'email', result: ValidationError.requiredField);
    sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

    test('Should emit form valid if email and password validation succeed', () async {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    });
  });

  group('authentication', () {
    test('Should call authentication with correct values', () async {
      validateForm();

      await sut.auth();

      verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
    });

    test('Should emit correct events on authentication success', () async {
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    });

    test('Should emit correct events on invalid credentials error', () async {
      mockAuthenticationError(DomainError.invalidCredentials);
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(
          sut.loginErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

      await sut.auth();
    });

    test('Should emit correct events on unexpected error', () async {
      mockAuthenticationError(DomainError.unexpected);
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(sut.loginErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.auth();
    });
  });

  group('save current account', () {
    test('Should call save current account with correct value', () async {
      validateForm();

      await sut.auth();

      verify(saveCurrentAccount.save(Account(token))).called(1);
    });

    test('Should emit unexpected error if save current account fails', () async {
      mockSaveCurrentAccountError();

      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(sut.loginErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.auth();
    });
  });

  group('navigation', () {
    test('Should change page on success', () async {
      validateForm();

      sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

      await sut.auth();
    });
  });
}
