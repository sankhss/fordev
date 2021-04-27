import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../usecases/authentication_factory.dart';

import 'login.dart';

LoginPresenter createLoginPresenter() {
  return StreamLoginPresenter(
    validation: createLoginValidation(),
    authentication: createRemoteAuthentication(),
  );
}
