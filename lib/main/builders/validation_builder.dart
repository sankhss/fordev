import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

class ValidationBuilder {
  String field;
  List<FieldValidation> validations = [];

  ValidationBuilder._(this.field);

  factory ValidationBuilder.field(String name) {
    return ValidationBuilder._(name);
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(field));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(field));
    return this;
  }

  List<FieldValidation> build() => validations;
}