import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/authentication_factory.dart';

import 'login.dart';

LoginPresenter createStreamLoginPresenter() {
  return StreamLoginPresenter(
    validation: createLoginValidation(),
    authentication: createRemoteAuthentication(),
  );
}

LoginPresenter createGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: createLoginValidation(),
    authentication: createRemoteAuthentication(),
  );
}
