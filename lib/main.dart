import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (settings) =>
          FostrRouter.generateRoute(context, settings),
      title: "FOSTR",
      home: Scaffold(
        body: const SplashScreen(),
      ),
    );
  }
}
