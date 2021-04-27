import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error != null && error.isNotEmpty) {
        return error;
      }
    }

    return error;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidation validation1;
  FieldValidation validation2;
  FieldValidation validation3;

  PostExpectation mockValidation(FieldValidation validation,
      {String field = 'any'}) {
    when(validation.field).thenReturn(field);
    return when(validation.validate(any));
  }

  void mockValidation1({String error}) {
    mockValidation(validation1).thenReturn(error);
  }

  void mockValidation2({String error}) {
    mockValidation(validation2, field: 'other').thenReturn(error);
  }

  void mockValidation3({String error}) {
    mockValidation(validation3).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2, validation3]);

    mockValidation1();
    mockValidation2();
    mockValidation3();
  });

  test('Should return null if all validations return null or empty', () {
    mockValidation2(error: '');

    expect(sut.validate(field: 'any', value: 'any'), null);
  });

  test('Should return the first error', () {
    mockValidation1(error: 'error1');
    mockValidation2(error: 'error2');
    mockValidation3(error: 'error3');

    expect(sut.validate(field: 'other', value: 'any'), 'error2');
  });
}
