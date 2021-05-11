import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

main() {
  SignUpPresenter presenter;
  StreamController nameErrorController;
  StreamController emailErrorController;
  StreamController passwordErrorController;
  StreamController passwordConfirmationErrorController;

  void mockStreams() {
    nameErrorController = StreamController<UIError>();
    when(presenter.nameErrorStream).thenAnswer((_) => nameErrorController.stream);

    emailErrorController = StreamController<UIError>();
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    passwordErrorController = StreamController<UIError>();
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);

    passwordConfirmationErrorController = StreamController<UIError>();
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

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

    final confirmPasswordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.confirmPassword), matching: find.byType(Text));
    expect(confirmPasswordTextChildren, findsOneWidget,
        reason: 'only one text child means it has no errors');

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel(R.strings.name), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel(R.strings.confirmPassword), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present correct error for name validation', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidName);
    await tester.pump();
    expect(find.text(UIError.invalidName.description), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.name),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason: 'only one text child means it has no errors');
  });

  testWidgets('Should present correct error for email validation', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidEmail);
    await tester.pump();
    expect(find.text(UIError.invalidEmail.description), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.email),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason: 'only one text child means it has no errors');
  });
}
