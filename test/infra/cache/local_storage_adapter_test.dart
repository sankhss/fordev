import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  FlutterSecureStorage secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save secure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw save secure errors', () async {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch secure', () {
    PostExpectation mockFetchSecureCall() => when(secureStorage.read(key: anyNamed('key')));

    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return value from fetch secure', () async {
      mockFetchSecureCall().thenAnswer((_) => Future.value(value));
      final token = await sut.fetchSecure(key);

      expect(token, value);
    });

    test('Should throw fetch secure errors', () async {
      mockFetchSecureCall().thenThrow(Exception());

      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
