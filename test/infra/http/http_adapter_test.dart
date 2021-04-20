import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri(path: url), headers: headers, body: jsonBody);
    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    url = faker.internet.httpUrl();
    sut = HttpAdapter(client);
  });
  group('post', () {
    PostExpectation mockRequest() => when(client.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ));

    void mockResponse(int statusCode, {String body = '{"any":"any"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, 200));
    }

    setUp(() {
      mockResponse(200);
    });
    test('Should post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'any': 'any'});

      verify(client.post(
        Uri(path: url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any":"any"}',
      ));
    });

    test('Should post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data on 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any': 'any'});
    });

    test('Should return null on 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null on 204', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
