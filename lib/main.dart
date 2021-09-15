import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fostr/providers/IndexProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/Locators.dart';
import 'package:fostr/services/RatingsService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
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

class FostrRouteObserver extends NavigatorObserver with FostrTheme {
  final RatingService _ratingService = GetIt.I<RatingService>();

  final BuildContext context;
  FostrRouteObserver(this.context);

  @override
  void didPop(Route route, Route? previousRoute) async {
    super.didPop(route, previousRoute);
    String name = route.settings.name ?? "";
    double ratings = 0;

    if (name == "minimal") {
      bool isRated = await _ratingService.isAlreadyRated();
      if (!isRated) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    height: 200,
                    child: Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "How mauch dyou want to rate this room?",
                            style: h1,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            maxRating: 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            glow: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.green[100],
                            ),
                            onRatingUpdate: (newRating) {
                              ratings = newRating;
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          MaterialButton(
                            color: Colors.blue[200],
                            onPressed: () {
                              _ratingService.addRating(ratings);
                              // Navigator.of(context).pop();
                            },
                            child: Text(
                              "Rate",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    }
  }
}
