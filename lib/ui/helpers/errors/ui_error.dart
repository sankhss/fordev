import '../helpers.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidEmail,
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
      default:
        return R.strings.unexpected;
    }
  }
}
