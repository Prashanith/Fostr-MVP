import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/providers/IndexProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/Locators.dart';
import 'package:fostr/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocators();
  runApp(MyApp());
}

class MyApp extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return IndexProvider(
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        onGenerateRoute: (settings) =>
            FostrRouter.generateRoute(context, settings),
        title: "FOSTR",
        home: SplashScreen(),
      ),
    );
  }
}
