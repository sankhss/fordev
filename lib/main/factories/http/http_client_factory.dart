import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http_adapter.dart';

HttpClient createHttpAdapter() {
  return HttpAdapter(Client());
}