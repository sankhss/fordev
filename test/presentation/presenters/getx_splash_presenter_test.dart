import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/account.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:meta/meta.dart';
import 'package:get/get.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString(null);

  Stream<String> get navigateToStream => _navigateTo.stream;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> loadCurrent() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}

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
    await sut.loadCurrent();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.loadCurrent();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.loadCurrent();
  });

  test('Should go to login page on exception', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.loadCurrent();
  });
}
