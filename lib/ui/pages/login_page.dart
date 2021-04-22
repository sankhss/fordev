import 'package:flutter/material.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LogoHeader(),
            Headline1('Login'),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text(
              'Enter'.toUpperCase(),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person),
            label: Text('Criar Conta'),
          ),
        ],
      ),
    );
  }
}
