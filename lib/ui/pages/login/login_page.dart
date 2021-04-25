import 'package:flutter/material.dart';

import '../../components/components.dart';
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
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => SimpleDialog(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10.0),
                            Text('Loading', textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ));
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });

        presenter.loginErrorStream.listen((error) {
          if (error != null && (error as String).isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Colors.red[900],
              ),
            );
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
                child: Form(
                  child: Column(
                    children: [
                      StreamBuilder<String>(
                          stream: presenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.email),
                                errorText: snapshot.data?.isNotEmpty == true
                                    ? snapshot.data
                                    : null,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: presenter.validateEmail,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                        child: StreamBuilder<String>(
                            stream: presenter.passwordErrorStream,
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
                                onChanged: presenter.validatePassword,
                              );
                            }),
                      ),
                      StreamBuilder<bool>(
                          stream: presenter.isFormValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed:
                                  snapshot.data == true ? presenter.auth : null,
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
            ],
          ),
        );
      }),
    );
  }
}
