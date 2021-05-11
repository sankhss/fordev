import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    Navigator.of(context).canPop();
    presenter.loadCurrent();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
      ),
    );
  }
}
