import '../helpers.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidEmail,
  invalidName,
  invalidPassword,
  passwordsDontMatch,
}

extension UIErrorProperties on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.invalidCredentials;
      case UIError.requiredField:
        return R.strings.required;
      case UIError.invalidEmail:
        return R.strings.invalidEmail;
      case UIError.invalidName:
        return R.strings.invalidName;
      case UIError.invalidPassword:
        return R.strings.invalidPassword;
      case UIError.passwordsDontMatch:
        return R.strings.passwordsDontMatch;
      default:
        return R.strings.unexpected;
    }
  }
}
