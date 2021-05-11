import 'package:get/get.dart';

import 'package:meta/meta.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = Rx<UIError>(null);
  var _passwordError = Rx<UIError>(null);
  var _isFormValid = RxBool(false);
  var _isLoading = RxBool(false);
  var _loginError = Rx<UIError>(null);
  var _navigateTo = RxString(null);

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<UIError> get loginErrorStream => _loginError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

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

  UIError _validate({@required String field, @required String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.requiredField;
      case ValidationError.invalidEmail:
        return UIError.invalidEmail;
      default:
        return null;
    }
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
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _loginError.refresh();
      switch (error) {
        case DomainError.invalidCredentials:
          _loginError.value = UIError.invalidCredentials;
          break;
        default:
          _loginError.value = UIError.unexpected;
          break;
      }
    }
    _isLoading.value = false;
  }

  void dispose() {}
}
