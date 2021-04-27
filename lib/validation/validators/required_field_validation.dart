import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value == null || value.isEmpty ? 'Required.' : null;
  }
}