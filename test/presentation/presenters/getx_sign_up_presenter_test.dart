import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:fordev/ui/helpers/helpers.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class ValidationSpy extends Mock implements Validation {}

class CreateAccountSpy extends Mock implements CreateAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

main() {
  GetxSignUpPresenter sut;
  CreateAccount createAccount;
  SaveCurrentAccount saveCurrentAccount;
  Validation validation;
  String name;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field ?? anyNamed('field'), value: anyNamed('value')));
  void mockValidation({String field, ValidationError result}) =>
      mockValidationCall(field).thenReturn(result);

  void validateForm() {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);
  }


  PostExpectation mockCreateAccountCall() => when(createAccount.create(any));
  void mockCreateAccountSuccess() => mockCreateAccountCall().thenAnswer((_) async => Account(token));
  void mockCreateAccountError(DomainError error) => mockCreateAccountCall().thenThrow(error);

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));
  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);


  setUp(() {
    createAccount = CreateAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      createAccount: createAccount,
      saveCurrentAccount: saveCurrentAccount,
      validation: validation,
    );
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockCreateAccountSuccess();
  });

  group('validation', () {
    group('name', () {
      test('Should call name validation', () {
        sut.validateName(name);

        verify(validation.validate(field: 'name', value: name)).called(1);
      });

      test('Should emit error if name is invalid', () {
        mockValidation(result: ValidationError.invalidName);

        sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidName)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validateName(name);
        sut.validateName(name);
      });

      test('Should emit error if name is empty', () {
        mockValidation(result: ValidationError.requiredField);

        sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validateName(name);
        sut.validateName(name);
      });

      test('Should emit null if name validation succeed', () {
        sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validateName(name);
        sut.validateName(name);
      });
    });

    group('email', () {
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
    });

    group('password', () {
      test('Should call password validation', () {
        sut.validatePassword(password);

        verify(validation.validate(field: 'password', value: password)).called(1);
      });

      test('Should emit error if password is invalid', () {
        mockValidation(result: ValidationError.invalidPassword);

        sut.passwordErrorStream
            .listen(expectAsync1((error) => expect(error, UIError.invalidPassword)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validatePassword(password);
        sut.validatePassword(password);
      });

      test('Should emit error if password is empty', () {
        mockValidation(result: ValidationError.requiredField);

        sut.passwordErrorStream
            .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
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
    });
    group('password confirmation', () {
      test('Should call validation for password confirmation', () {
        sut.validatePasswordConfirmation(password);

        verify(validation.validate(field: 'passwordConfirmation', value: password)).called(1);
      });

      test('Should emit error if password confirmation is invalid', () {
        mockValidation(result: ValidationError.dontMatch);

        sut.passwordConfirmationErrorStream
            .listen(expectAsync1((error) => expect(error, UIError.passwordsDontMatch)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validatePasswordConfirmation(password);
        sut.validatePasswordConfirmation(password);
      });

      test('Should emit error if password confirmation is empty', () {
        mockValidation(result: ValidationError.requiredField);

        sut.passwordConfirmationErrorStream
            .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validatePasswordConfirmation(password);
        sut.validatePasswordConfirmation(password);
      });

      test('Should emit null if password confirmaton succeed', () {
        sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        sut.validatePasswordConfirmation(password);
        sut.validatePasswordConfirmation(password);
      });
    });

    group('form', () {
      test('Should emit error if any validation fails', () {
        mockValidation(field: 'name', result: ValidationError.requiredField);
        sut.isFormValidStream.listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

        validateForm();
      });

      test('Should emit form valid if all validation succeed', () async {
        expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

        sut.validateName(name);
        await Future.delayed(Duration.zero);
        sut.validateEmail(email);
        await Future.delayed(Duration.zero);
        sut.validatePassword(password);
        await Future.delayed(Duration.zero);
        sut.validatePasswordConfirmation(password);
        await Future.delayed(Duration.zero);
      });
    });
  });

  group('create account', () {
    test('Should call create account with correct values', () async {
      validateForm();

      await sut.signUp();

      verify(createAccount.create(CreateAccountParams(
              name: name, email: email, password: password, passwordConfirmation: password)))
          .called(1);
    });

    test('Should emit correct events on create account success', () async {
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.signUp();
    });

    test('Should emit correct events on account already exists error', () async {
      mockCreateAccountError(DomainError.alreadyExists);
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(sut.signUpErrorStream, emits(UIError.alreadyExists));

      await sut.signUp();
    });

    test('Should emit correct events on unexpected error', () async {
      mockCreateAccountError(DomainError.unexpected);
      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(sut.signUpErrorStream, emits(UIError.unexpected));

      await sut.signUp();
    });
  });

  group('save current account', () {
    test('Should call save current account with correct value', () async {
      validateForm();

      await sut.signUp();

      verify(saveCurrentAccount.save(Account(token))).called(1);
    });

    test('Should emit unexpected error if save current account fails', () async {
      mockSaveCurrentAccountError();

      validateForm();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      expectLater(sut.signUpErrorStream, emits(UIError.unexpected));

      await sut.signUp();
    });
  });

  group('navigation', () {
    test('Should change page on success', () async {
      validateForm();

      sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

      await sut.signUp();
    });
  });
}
