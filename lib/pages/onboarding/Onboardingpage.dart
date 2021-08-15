import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/clubOwner/dashboard.dart';
import 'package:fostr/pages/onboarding/SplashScreen.dart';
import 'package:fostr/pages/user/HomePage.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with FostrTheme {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoading) {
      if (auth.logedIn) {
        if (auth.userType == UserType.CLUBOWNER) {
          return Dashboard();
        } else if (auth.userType == UserType.USER) {
          return UserDashboard();
        } else {
          return SplashScreen();
        }
      } else {
        return SplashScreen();
      }
    }
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset(IMAGES + "background.png").image,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Image.asset(IMAGES + "logo_black.png").image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 50.w,
              child: Image.asset(IMAGES + "fostreads.png")
            ),
            SizedBox(height: 25),
            Text("Loading...", style: h1),
            CircularProgressIndicator(
              backgroundColor: Color(0xff47A389),
              valueColor: AlwaysStoppedAnimation<Color>(gradientTop),
            ),
          ],
        ),
      )
    );
  }
}
