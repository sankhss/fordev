import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class CreateAccount {
  Future<Account> create(CreateAccountParams params);
}

class CreateAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  CreateAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List get props => [name, email, password, passwordConfirmation];
}
