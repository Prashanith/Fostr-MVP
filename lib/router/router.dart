import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/AddDetails.dart';
import 'package:fostr/pages/onboarding/LoginPage.dart';
import 'package:fostr/pages/onboarding/Onboardingpage.dart';
import 'package:fostr/pages/onboarding/OtpVerification.dart';
import 'package:fostr/pages/onboarding/SignupPage.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/pages/onboarding/UserChoice.dart';
import 'package:fostr/pages/quiz/AnalyzingPage.dart';
import 'package:fostr/pages/quiz/BookSuggestionPage.dart';
import 'package:fostr/pages/quiz/Quiz.dart';
import 'package:fostr/pages/quiz/QuizIntro.dart';
import 'package:fostr/pages/quiz/QuizPage.dart';
import 'package:fostr/router/routes.dart';

class FostrRouter {
  static goto(BuildContext context, String route) =>
      Navigator.pushNamed(context, route);

  static replaceGoto(BuildContext context, String route) =>
      Navigator.pushReplacementNamed(context, route);

  static removeUntillAndGoto(BuildContext context, String route,
          bool Function(Route<dynamic> route) predicate) =>
      Navigator.pushNamedAndRemoveUntil(context, route, predicate);

  static pop(BuildContext context) => Navigator.pop(context);

  static Route<dynamic> generateRoute(
    BuildContext context,
    RouteSettings settings,
  ) =>
      CupertinoPageRoute(
        settings: settings,
        builder: (context) => _generateView(settings),
      );

  static Widget _generateView(RouteSettings settings) {
    switch (settings.name) {
      case Routes.entry:
        return OnboardingPage();

      case Routes.splash:
        return SplashScreen();

      case Routes.userChoice:
        return UserChoice();

      case Routes.singup:
        return SignupPage();

      case Routes.login:
        return LoginPage();

      case Routes.otpVerification:
        return OtpVerification();

      case Routes.addDetails:
        return AddDetails();

      case Routes.quizPage:
        return QuizPage();

      case Routes.quizIntro:
        return QuizIntro();

      case Routes.quiz:
        return Quiz();

      case Routes.analyzingPage:
        return AnalyzingPage();

      case Routes.bookClubSuggetion:
        return BookSuggestionPage();

      default:
        return Material(
          child: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
