import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/account.dart';

import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<Account> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return Account(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}