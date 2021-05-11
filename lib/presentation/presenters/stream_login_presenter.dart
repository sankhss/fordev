import 'dart:async';

import 'package:meta/meta.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class LoginState {
  bool isLoading = false;
  String email;
  String password;
  UIError emailError;
  UIError passwordError;
  UIError loginError;
  String navigateTo;

  bool get isFormValid =>
      emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  StreamLoginPresenter({@required this.validation, @required this.authentication});

  Stream<UIError> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<UIError> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();
  Stream<UIError> get loginErrorStream =>
      _controller.stream.map((state) => state.loginError).distinct();
  Stream<String> get navigateToStream =>
      _controller.stream.map((state) => state.navigateTo).distinct();

  void _update() {
    if (!_controller.isClosed) {
      _controller.add(_state);
    }
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validate(field: 'password', value: password);
    _update();
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

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.loginError = UIError.invalidCredentials;
          break;
        default:
          _state.loginError = UIError.unexpected;
          break;
      }
    }
    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller.close();
  }
}
