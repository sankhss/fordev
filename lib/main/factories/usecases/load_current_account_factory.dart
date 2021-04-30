import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

import '../../factories/cache/cache.dart';

LoadCurrentAccount createLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(fetchSecureCacheStorage: createLocalStorageAdapter());
}