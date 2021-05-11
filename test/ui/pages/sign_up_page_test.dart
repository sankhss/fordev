import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {

  Future<void> loadPage(WidgetTester tester) async {

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage()),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.name), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget, reason: 'only one text child means it has no errors');

    final emailTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.email), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget, reason: 'only one text child means it has no errors');

    final passwordTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.password), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason: 'only one text child means it has no errors');

    final confirmPasswordTextChildren =
        find.descendant(of: find.bySemanticsLabel(R.strings.confirmPassword), matching: find.byType(Text));
    expect(confirmPasswordTextChildren, findsOneWidget,
        reason: 'only one text child means it has no errors');

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
