import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

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

abstract class SplashPresenter {
  Stream<String> navigateToStream;

  Future<void> loadCurrentAccount();
}

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

    verify(presenter.loadCurrentAccount()).called(1);
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
