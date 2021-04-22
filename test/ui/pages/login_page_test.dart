import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';

main() {

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget, reason: 'only one text child means it has no errors');

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Password'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget, reason: 'only one text child means it has no errors');

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);
  });
  
}