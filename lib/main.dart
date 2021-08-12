import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fostr/providers/IndexProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/Locators.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocators();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final instance = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    instance.subscribeToTopic("test");
  }

  @override
  Widget build(BuildContext context) {
    return IndexProvider(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                secondary: Colors.white,
              ),
            ),
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            initialRoute: "/",
            onGenerateRoute: (settings) =>
                FostrRouter.generateRoute(context, settings),
            title: "FOSTR",
          );
        },
      ),
    );
  }
}
