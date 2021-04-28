import 'package:get/get.dart';

import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String _email;
  String _password;

  var _emailError = RxString(null);
  var _passwordError = RxString(null);
  var _isFormValid = RxBool(false);
  var _isLoading = RxBool(false);
  var _loginError = RxString(null);

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get loginErrorStream => _loginError.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (error) {
      _loginError.refresh();
      _loginError.value = error.description;
    }
    _isLoading.value = false;
  }

  void dispose() {}
}
