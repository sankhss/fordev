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
  StreamController signUpErrorController;
  StreamController isFormValidController;
  StreamController isLoadingController;
  StreamController navigateToController;

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

    signUpErrorController = StreamController<UIError>();
    when(presenter.signUpErrorStream)
        .thenAnswer((_) => signUpErrorController.stream);

    isFormValidController = StreamController<bool>();
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    
    isLoadingController = StreamController<bool>();
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    signUpErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
        GetPage(name: '/fake', page: () => Scaffold(body: Text('fake_page'))),
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

  testWidgets('Should present correct error for password validation', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidPassword);
    await tester.pump();
    expect(find.text(UIError.invalidPassword.description), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.password),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason: 'only one text child means it has no errors');
  });

  testWidgets('Should present correct error for password confirmation validation', (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.passwordsDontMatch);
    await tester.pump();
    expect(find.text(UIError.passwordsDontMatch.description), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(UIError.requiredField.description), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
          of: find.bySemanticsLabel(R.strings.confirmPassword),
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

    var enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);

    isFormValidController.add(null);
    await tester.pump();

    enterButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(enterButton.enabled, false);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final finder = find.byType(ElevatedButton);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();

    verify(presenter.signUp()).called(1);
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

  testWidgets('Should show correct error message if sign up fails', (WidgetTester tester) async {
    await loadPage(tester);

    signUpErrorController.add(UIError.alreadyExists);
    await tester.pump();
    expect(find.text(UIError.alreadyExists.description), findsOneWidget);
  });

  testWidgets('Should show correct error message if sign up throws unexpected', (WidgetTester tester) async {
    await loadPage(tester);

    signUpErrorController.add(UIError.unexpected);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
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
    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/signup');
  });
}
