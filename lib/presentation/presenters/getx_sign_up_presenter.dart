import 'package:meta/meta.dart';
import 'package:get/get.dart';


import '../../ui/helpers/helpers.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  var _nameError = Rx<UIError>(null);
  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _passwordConfirmationError = Rx<UIError>(null);
  var _isFormValid = false.obs;


  GetxSignUpPresenter({
    @required this.validation,
  });

  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void validateName(String name) {
    _nameError.value = _validate(field: 'name', value: name);
    _validateForm();
  }

  void validateEmail(String email) {
    _emailError.value = _validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordError.value = _validate(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmationError.value = _validate(field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  UIError _validate({@required String field, @required String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.requiredField;
      case ValidationError.invalidEmail:
        return UIError.invalidEmail;
      case ValidationError.invalidPassword:
        return UIError.invalidPassword;
      case ValidationError.invalidName:
        return UIError.invalidName;
      case ValidationError.dontMatch:
        return UIError.passwordsDontMatch;
      default:
        return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = false;
  }
}
