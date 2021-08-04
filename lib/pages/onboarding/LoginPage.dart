import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fostr/pages/onboarding/Layout.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/Helpers.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/SigninWithGoogle.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with FostrTheme {
  final loginForm = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isError = false;
  String error = "";

  void handlePasswordField() {
    if (Validator.isEmail(idController.text)) {
      setState(() {
        isVisible = true;
      });
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    idController.addListener(handlePasswordField);
  }

  @override
  void dispose() {
    super.dispose();
    idController.removeListener(handlePasswordField);
    idController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Layout(
        child: Padding(
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
            child: Text("Welcome Back!", style: h1),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please Login into your account ",
            style: h2,
          ),
          SizedBox(
            height: 90,
          ),
          Form(
            key: loginForm,
            child: Column(
              children: [
                InputField(
                  validator: (value) {
                    if (isError) {
                      isError = false;
                      return error;
                    }
                    if (!Validator.isEmail(value!) &&
                        !Validator.isPhone(value)) {
                      return "Please provide correct values";
                    }
                    return null;
                  },
                  controller: idController,
                  hintText: "Email or Mobile Number",
                ),
                SizedBox(
                  height: 20,
                ),
                (isVisible)
                    ? InputField(
                        isPassword: true,
                        validator: (value) {
                          if (passwordController.text.length < 6) {
                            return "Password dose not match";
                          }
                        },
                        controller: passwordController,
                        hintText: "Password",
                      )
                    : Container(),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              children: [
                SigninWithGoogle(
                  text: "Login With Google",
                  onTap: () async {
                    auth
                        .signInWithGoogle(auth.userType!)
                        .catchError(handleError)
                        .then((user) {
                      if (user != null && user.createdOn == user.lastLogin) {
                        FostrRouter.goto(context, Routes.addDetails);
                      } else {
                        print("done");
                      }
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  text: "Login",
                  onTap: () async {
                    if (loginForm.currentState!.validate() && !auth.isLoading) {
                      if (Validator.isEmail(idController.text.trim())) {
                        await auth
                            .signInWithEmailPassword(
                          idController.text.trim(),
                          passwordController.text.trim(),
                          auth.userType!,
                        )
                            .then((value) {
                          // FostrRouter.goto(context, R)
                        }).catchError(handleError);
                      } else if (Validator.isPhone(idController.text.trim()) &&
                          !auth.isLoading) {
                        await auth
                            .signInWithPhone(context, idController.text.trim())
                            .then((value) {
                          FostrRouter.goto(context, Routes.otpVerification);
                        }).catchError(handleError);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?  ",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FostrRouter.goto(context, Routes.singup);
                      },
                      child: Text(
                        "Sign Up",
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
    ));
  }

  FutureOr<Null> handleError(Object error) async {
    log(error.toString());
    setState(() {
      isError = true;
      this.error = showAuthError(error.toString());
    });
    loginForm.currentState!.validate();
  }
}
