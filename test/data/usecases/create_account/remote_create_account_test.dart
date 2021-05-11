import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteCreateAccount sut;
  HttpClientSpy httpClient;
  String url;
  CreateAccountParams params;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteCreateAccount(httpClient: httpClient, url: url);
    final password = faker.internet.password();
    params = CreateAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password,
    );
  });

  test('Should call HttpClient with correct values', () async {
    await sut.create(params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'name': params.name,
      'email': params.email,
      'password': params.password,
      'passwordConfirmation': params.passwordConfirmation,
    }));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final response = sut.create(params);

    expect(response, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final response = sut.create(params);

    expect(response, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final response = sut.create(params);

    expect(response, throwsA(DomainError.unexpected));
  });
}
