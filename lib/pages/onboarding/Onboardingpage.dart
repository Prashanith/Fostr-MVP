import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
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
        if (auth.userType == UserType.CLUBOWNER) {}
        // return HomeScreen();
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
