import 'strings.dart';

class PtBr implements Translations {
  @override
  String get createAccount => 'Criar conta';
  @override
  String get email => 'E-mail';
  @override
  String get enter => 'Entrar';
  @override
  String get login => 'Login';
  @override
  String get password => 'Senha';

  @override
  String get invalidCredentials => 'Credenciais inválidas.';
  @override
  String get invalidEmail => 'Este não é um e-mail válido';
  @override
  String get required => 'Campo obrigatório';
  @override
  String get unexpected => 'Um erro inesperado ocorreu. Tente novamente.';
}