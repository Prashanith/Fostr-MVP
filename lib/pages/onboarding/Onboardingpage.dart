import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/clubOwner/dashboard.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/pages/user/HomePage.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoading) {
      if (auth.logedIn) {
        if (auth.user!.userType == UserType.CLUBOWNER) {
          return Dashboard();
        } else if (auth.user!.userType == UserType.USER) {
          return OngoingRoom();
        } else {
          return SplashScreen();
        }
      } else {
        return SplashScreen();
      }
    }
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("FOSTR", style: TextStyle(color: Colors.teal))),
        CircularProgressIndicator(color: Colors.teal),
      ],
    ));
  }
}
