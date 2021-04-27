import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

import '../http/http.dart';

Authentication createRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: createHttpAdapter(),
    url: createApiUrl('login'),
  );
}
