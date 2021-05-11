import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  LoginPresenter presenter;
  StreamController emailErrorController;
  StreamController passwordErrorController;
  StreamController isFormValidController;
  StreamController isLoadingController;
  StreamController loginErrorController;
  StreamController navigateToController;

  void mockStreams() {
    emailErrorController = StreamController<UIError>();
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    passwordErrorController = StreamController<UIError>();
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);

    isFormValidController = StreamController<bool>();
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);

    isLoadingController = StreamController<bool>();
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);

    loginErrorController = StreamController<UIError>();
    when(presenter.loginErrorStream).thenAnswer((_) => loginErrorController.stream);

    navigateToController = StreamController<String>();
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    loginErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    mockStreams();

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter)),
        GetPage(name: '/fake', page: () => Scaffold(body: Text('fake_page'))),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren =
        find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget, reason: 'only one text child means it has no errors');

    final passwordTextChildren =
        find.descendant(of: find.bySemanticsLabel('Password'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason: 'only one text child means it has no errors');

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Password'), password);

    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidEmail);
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason: 'only one text child means it has no errors');
  });

  testWidgets('Should present error if password is empty', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
        find.descendant(
          of: find.bySemanticsLabel('Password'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason: 'only one text child means it has no errors');
  });

  testWidgets('Should enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, true);
  });

  testWidgets('Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);
  });

  testWidgets('Should disable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(null);
    await tester.pump();

    final enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);
  });

  testWidgets('Should call authentication on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final finder = find.byType(ElevatedButton);

    await tester.ensureVisible(finder);
    await tester.pump();

    await tester.tap(finder);
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should show error message if login fails', (WidgetTester tester) async {
    await loadPage(tester);

    loginErrorController.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Invalid credentials.'), findsOneWidget);
  });

  testWidgets('Should show error message if login throws', (WidgetTester tester) async {
    await loadPage(tester);

    loginErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Unexpected error. Try again later.'), findsOneWidget);
  });

  testWidgets('Should navigate to page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/fake');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake');
    expect(find.text('fake_page'), findsOneWidget);
  });

  testWidgets('Sould not navigate to page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/login');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/login');
  });
}
