import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client.post(Uri(path: url), headers: headers, body: jsonBody);
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
  });
}
