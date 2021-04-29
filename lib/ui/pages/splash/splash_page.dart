import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen((page) {
            if (page != null && page.isNotEmpty) {
              Get.offAllNamed(page);
            }
          });

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
