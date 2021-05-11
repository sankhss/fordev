enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidEmail,
}

extension UIErrorProperties on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials: return 'Invalid credentials.';
      case UIError.requiredField: return 'Required';
      case UIError.invalidEmail: return 'Please enter a valid email';
      default: return 'Unexpected error. Try again later.';
    }
  }
}