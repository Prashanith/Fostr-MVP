import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/SignupPage.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/router/routes.dart';

class FostrRouter {
  static goto(BuildContext context, String name) =>
      Navigator.pushNamed(context, name);
  
  static replaceGoto(BuildContext context, String name) =>
      Navigator.pushReplacementNamed(context, name);

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

      case Routes.singup:
        return SignupPage();
      default:
        return Material(
          child: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
