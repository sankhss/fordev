import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';
import 'package:fordev/validation/protocols/protocols.dart';

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

  void mockValidation1({ValidationError error}) {
    mockValidation(validation1).thenReturn(error);
  }

  void mockValidation2({ValidationError error}) {
    mockValidation(validation2, field: 'other').thenReturn(error);
  }

  void mockValidation3({ValidationError error}) {
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
    expect(sut.validate(field: 'any', value: 'any'), null);
  });

  test('Should return the first error', () {
    mockValidation1(error: ValidationError.invalidEmail);
    mockValidation2(error: ValidationError.requiredField);
    mockValidation3(error: ValidationError.invalidEmail);

    expect(sut.validate(field: 'other', value: 'any'), ValidationError.requiredField);
  });
}
