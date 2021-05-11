import '../../helpers/helpers.dart';

abstract class LoginPresenter {
  Stream<bool> get isFormValidStream;
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<UIError> get loginErrorStream;
  Stream<String> get navigateToStream;

  void validateEmail(String email);
  void validatePassword(String password);

  Future<void> auth();
  void dispose();
}