import 'strings.dart';

class EnUs implements Translations {
  String get confirmPassword => 'Confirm password';
  String get createAccount => 'Create account';
  String get email => 'Email';
  String get enter => 'Enter';
  String get login => 'Login';
  String get name => 'Name';
  String get password => 'Password';

  String get invalidCredentials => 'Invalid credentials.';
  String get invalidEmail => 'Please enter a valid email';
  String get invalidName => 'Please enter a valid name';
  String get invalidPassword => 'Password must have at least 3 characters';
  String get passwordsDontMatch => 'Passwords don\'t match';
  String get required => 'Required';
  String get unexpected => 'Unexpected error. Try again later.';
}