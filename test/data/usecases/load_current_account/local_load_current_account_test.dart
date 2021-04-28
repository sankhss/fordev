import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/account.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  String token;

  PostExpectation mockFetchSecureCall() {
    return when(fetchSecureCacheStorage.fetchSecure(any));
  }

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) => Future.value(token));
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecure();
  });

  test('Should call fetch secure cache storage with correct values', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return unexpect error if fetch secure cache storage throws', () {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return an account', () async {
    final account = await sut.load();

    expect(account, Account(token));
  });
}
