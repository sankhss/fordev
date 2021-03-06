import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  GetxSplashPresenter sut;
  LoadCurrentAccount loadCurrentAccount;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({Account account}) =>
      mockLoadCurrentAccountCall().thenAnswer((_) => Future.value(account));

  void mockLoadCurrentAccountError() => mockLoadCurrentAccountCall().thenThrow(Exception());

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    mockLoadCurrentAccount(account: Account(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.loadCurrent(durationInSeconds: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.loadCurrent();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.loadCurrent(durationInSeconds: 0);
  });

  test('Should go to login page on exception', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.loadCurrent(durationInSeconds: 0);
  });
}
