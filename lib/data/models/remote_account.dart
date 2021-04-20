import 'package:fordev/domain/entities/account.dart';

class RemoteAccount {
  final String token;

  RemoteAccount(this.token);

  factory RemoteAccount.fromJson(Map json) => RemoteAccount(json['accessToken']);

  Account toEntity() => Account(token);
}