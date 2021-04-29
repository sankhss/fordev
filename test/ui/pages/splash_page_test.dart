import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenter presenter;
  StreamController navigateToController;

  setUp(() {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  });

  tearDown(() {
    navigateToController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
          GetPage(name: '/fake', page: () => Scaffold(body: Text('fake_page'))),
        ],
      ),
    );
  }

  testWidgets('Sould present spinner on loading', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Sould call load current account on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrent()).called(1);
  });

  testWidgets('Sould change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/fake');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake');
    expect(find.text('fake_page'), findsOneWidget);
  });

  testWidgets('Sould not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/');
  });
}
