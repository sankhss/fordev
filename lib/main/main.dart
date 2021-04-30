import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../ui/components/components.dart';

import 'factories/factories.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: '4Dev',
        theme: createAppTheme(),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: createSplashPage, transition: Transition.fade),
          GetPage(name: '/login', page: createLoginPage, transition: Transition.fadeIn),
          GetPage(
            name: '/surveys',
            page: () => Scaffold(body: Text('Surveys')),
            transition: Transition.fadeIn,
          ),
        ],
      ),
    );
  }
}
