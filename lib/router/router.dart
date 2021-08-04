import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/AddDetails.dart';
import 'package:fostr/pages/onboarding/LoginPage.dart';
import 'package:fostr/pages/onboarding/OtpVerification.dart';
import 'package:fostr/pages/onboarding/SignupPage.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/pages/onboarding/UserChoice.dart';
import 'package:fostr/router/routes.dart';

class FostrRouter {
  static goto(BuildContext context, String name) =>
      Navigator.pushNamed(context, name);

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

      default:
        return Material(
          child: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
