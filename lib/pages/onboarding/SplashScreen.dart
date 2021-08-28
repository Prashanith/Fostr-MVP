import 'package:flutter/material.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/widgets/Buttons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              IMAGES + "onboarding.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                "FOSTR READS",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: "Lato",
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Wheather we create history or not\nwe are a part of history",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Lato",
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height:222,
              ),
              
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 111),
              child: PrimaryButton(
                text: "Get Started",
                onTap: () {
                  FostrRouter.goto(context, Routes.userChoice);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
