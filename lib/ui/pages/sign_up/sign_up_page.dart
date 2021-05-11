import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage(this.presenter, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoadingSpinner(context);
          } else {
            hideLoadingSpinner(context);
          }
        });

        presenter.signUpErrorStream.listen((error) {
          if (error != null) {
            showErrorSnackBar(context, message: error.description);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page != null && page.isNotEmpty) {
            Get.offAllNamed(page);
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LogoHeader(),
              Headline1(R.strings.createAccount),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Provider<SignUpPresenter>(
                  create: (_) => presenter,
                  child: Form(
                    child: Column(
                      children: [
                        NameInput(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: EmailInput(),
                        ),
                        PasswordInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                          child: PasswordConfirmationInput(),
                        ),
                        SignUpButton(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.exit_to_app),
                          label: Text(R.strings.login),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
