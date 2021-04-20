import '../../domain/entities/account.dart';

import '../http/http.dart';

class RemoteAccount {
  final String token;

  RemoteAccount(this.token);

  factory RemoteAccount.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccount(json['accessToken']);
  }

  Account toEntity() => Account(token);
}