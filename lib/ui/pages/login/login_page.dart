import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

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

        presenter.loginErrorStream.listen((error) {
          if (error != null && error.isNotEmpty) {
            showErrorSnackBar(context, message: error);
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
              Headline1('Login'),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Provider(
                  create: (_) => presenter,
                  child: Form(
                    child: Column(
                      children: [
                        EmailInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                          child: PasswordInput(),
                        ),
                        LoginButton(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                          label: Text('Create account Conta'),
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
