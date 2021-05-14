import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final CreateAccount createAccount;
  final Validation validation;

  var _nameError = Rx<UIError>(null);
  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _passwordConfirmationError = Rx<UIError>(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  GetxSignUpPresenter({
    @required this.createAccount,
    @required this.validation,
  });

  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  Future<void> signUp() async {
    _isLoading.value = true;
    await createAccount.create(
      CreateAccountParams(
          name: _name,
          email: _email,
          password: _password,
          passwordConfirmation: _passwordConfirmation),
    );
    _isLoading.value = false;
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validate(field: 'name', value: name);
    _validateForm();
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validate(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value =
        _validate(field: 'passwordConfirmation', value: passwordConfirmation);
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
    _isFormValid.value = _nameError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }
}
