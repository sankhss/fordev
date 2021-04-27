import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

main() {
  StreamLoginPresenter sut;
  Validation validation;
  Authentication authentication;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String field, String result}) =>
      mockValidationCall(field).thenReturn(result);

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() =>
      mockAuthenticationCall().thenAnswer((_) async => Account(faker.guid.guid()));

  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();

    mockValidation();
    mockAuthentication();
  });

  test('Should call email Validation', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit error if email validation fails', () {
    mockValidation(result: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email validation succeed', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call password Validation', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit error if password validation fails', () {
    mockValidation(result: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeed', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit error if any validation fails', () {
    mockValidation(field: 'email', result: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isFormValid) => expect(isFormValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit form valid if email and password validation succeed',
      () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call authentication eith correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should emit correct events on authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on invalid credentials error', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.loginErrorStream.listen(expectAsync1((error) => expect(error, DomainError.invalidCredentials.description)));

    await sut.auth();
  });

  test('Should emit correct events on unexpected error', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.loginErrorStream.listen(expectAsync1((error) => expect(error, DomainError.unexpected.description)));

    await sut.auth();
  });
}
