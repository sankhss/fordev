abstract class LoginPresenter {
  Stream<bool> get isFormValidStream;
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get loginErrorStream;

  void validateEmail(String email);
  void validatePassword(String password);

  Future<void> auth();
  void dispose();
}