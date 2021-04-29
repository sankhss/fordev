import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashPage()),
        ],
      ),
    );
  }
  testWidgets('Sould present spinner on loading', (WidgetTester tester) async {
    loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
