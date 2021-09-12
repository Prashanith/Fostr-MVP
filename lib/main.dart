

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fostr/providers/IndexProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/Locators.dart';
import 'package:fostr/services/RatingsService.dart';
import 'package:get_it/get_it.dart';


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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IndexProvider(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: FostrApp(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                secondary: Colors.white,
              ),
            ),
            title: "FOSTR",
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
          );
        },
      ),
    );
  }
}

class FostrApp extends StatelessWidget {
  const FostrApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: (settings) =>
          FostrRouter.generateRoute(context, settings),
      title: "FOSTR",
      navigatorObservers: [FostrRouteObserver(context)],
    );
  }
}

class FostrRouteObserver extends NavigatorObserver {
  final RatingService _ratingService = GetIt.I<RatingService>();

  final BuildContext context;
  FostrRouteObserver(this.context);

  @override
  void didPop(Route route, Route? previousRoute) async {
    super.didPop(route, previousRoute);
    String name = route.settings.name ?? "";

    if (name == "minimal") {
      bool isRated = await _ratingService.isAlreadyRated();
      if (!isRated) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Material(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }
}
