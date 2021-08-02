import 'package:flutter/material.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Background.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/SigninWithGoogle.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Background(),
          Padding(
            padding: paddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 140,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("Create New Account", style: h1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please fill the form to continue",
                  style: h2,
                ),
                SizedBox(
                  height: 90,
                ),
                Form(
                  child: InputField(
                    hintText: "Email or Mobile Number",
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
                      SigninWithGoogle(
                          text: "Signup With Google", onTap: () {}),
                      SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                        text: "Send OTP",
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account?  ",
                            style: TextStyle(
                              fontFamily: "Lato",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              FostrRouter.goto(context, Routes.signin);
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: Color(0xff476747),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
