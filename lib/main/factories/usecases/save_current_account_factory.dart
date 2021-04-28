import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

import '../../factories/cache/cache.dart';

SaveCurrentAccount createLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: createLocalStorageAdapter());
}