import 'package:fordev/domain/entities/entities.dart';

class Account {
  final String token;

  Account(this.token);

  factory Account.fromJson(Map json) => Account(json['accessToken']);
}