import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/usecases.dart';

SplashPresenter createGetxSplashPresenter() {
  return GetxSplashPresenter(
    loadCurrentAccount: createLocalLoadCurrentAccount(),
  );
}
