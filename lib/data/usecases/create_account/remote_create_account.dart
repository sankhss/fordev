import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteCreateAccount implements CreateAccount {
  final HttpClient httpClient;
  final String url;

  RemoteCreateAccount({@required this.httpClient, @required this.url});

  Future<Account> create(CreateAccountParams params) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteCreateAccountParams.fromDomain(params).toJson(),
      );
      return null;
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteCreateAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteCreateAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteCreateAccountParams.fromDomain(CreateAccountParams params) =>
      RemoteCreateAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
