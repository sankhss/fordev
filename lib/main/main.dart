import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/route_manager.dart';

import '../ui/components/components.dart';

import 'factories/factories.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      theme: createAppTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: createLoginPage),
      ],
    );
  }
}