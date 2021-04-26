import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
    void dispose() {
      super.dispose();
      widget.presenter.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoadingSpinner(context);
          } else {
            hideLoadingSpinner(context);
          }
        });

        widget.presenter.loginErrorStream.listen((error) {
          if (error != null && error.isNotEmpty) {
            showErrorSnackBar(context, message: error);
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
                  create: (_) => widget.presenter,
                  child: Form(
                    child: Column(
                      children: [
                        EmailInput(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                          child: StreamBuilder<String>(
                              stream: widget.presenter.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.lock),
                                    errorText: snapshot.data?.isNotEmpty == true
                                        ? snapshot.data
                                        : null,
                                  ),
                                  obscureText: true,
                                  onChanged: widget.presenter.validatePassword,
                                );
                              }),
                        ),
                        StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed:
                                    snapshot.data == true ? widget.presenter.auth : null,
                                child: Text(
                                  'Enter'.toUpperCase(),
                                ),
                              );
                            }),
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
