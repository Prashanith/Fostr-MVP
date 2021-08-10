import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/quiz/BookSuggestionPage.dart';
import 'package:fostr/providers/IndexProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/Locators.dart';
import 'package:fostr/utils/theme.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocators();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return IndexProvider(
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          initialRoute: "/",
          onGenerateRoute: (settings) =>
              FostrRouter.generateRoute(context, settings),
          title: "FOSTR",
        ),
      ),
    );
  }
}
