import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = RxString(null);

  Stream<String> get navigateToStream => _navigateTo.stream;

  GetxSplashPresenter({this.loadCurrentAccount});

  @override
  Future<void> loadCurrent() async {
    await loadCurrentAccount.load();
  }

}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  GetxSplashPresenter sut;
  LoadCurrentAccount loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.loadCurrent();

    verify(loadCurrentAccount.load()).called(1);
  });
}