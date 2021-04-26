import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.email),
            errorText: snapshot.data?.isNotEmpty == true ? snapshot.data : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
