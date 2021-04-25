abstract class LoginPresenter {
  Stream get isFormValidStream;
  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String password);

  void auth();
}