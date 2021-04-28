import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    final isValid = value == null || value.isEmpty || regex.hasMatch(value);
    return isValid ? null : 'Please enter a valid email';
  }

  @override
  List<Object> get props => [field];
}