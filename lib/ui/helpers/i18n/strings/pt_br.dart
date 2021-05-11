import 'strings.dart';

class PtBr implements Translations {
  String get confirmPassword => 'Confirmar senha';
  String get createAccount => 'Criar conta';
  String get email => 'E-mail';
  String get enter => 'Entrar';
  String get login => 'Login';
  String get name => 'Nome';
  String get password => 'Senha';

  String get alreadyExists => 'Já existe uma conta para este e-mail.';
  String get invalidCredentials => 'Credenciais inválidas.';
  String get invalidEmail => 'Este não é um e-mail válido';
  String get invalidName => 'Este nome não é válido';
  String get invalidPassword => 'Senha deve ter ao menos 3 caracteres';
  String get passwordsDontMatch => 'As senhas não batem';
  String get required => 'Campo obrigatório';
  String get unexpected => 'Um erro inesperado ocorreu. Tente novamente.';
}