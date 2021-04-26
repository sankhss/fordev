import 'dart:async';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  StreamLoginPresenter({@required this.validation});

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError);


  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

class ValidationSpy extends Mock implements Validation {}

main() {
  StreamLoginPresenter sut;
  Validation validation;
  String email;

  PostExpectation mockValidationCall(String field) {
    return when(validation.validate(field: field ?? anyNamed('field'), value: anyNamed('value')));
  }

  void mockValidation({String field, String result}) {
    mockValidationCall(field).thenReturn(result);
  }

  setUp((){
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();

    mockValidation();
  });

  test('Should call email Validation', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit error if validation fails', () {
    mockValidation(result: 'error');

    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}