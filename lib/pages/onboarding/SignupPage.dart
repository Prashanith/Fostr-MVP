import 'dart:async';

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

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with FostrTheme {
  final signupForm = GlobalKey<FormState>();

  bool isEmail = false;
  bool isError = false;
  String error = "";

  TextEditingController _controller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void handlePasswordField() {
    if (Validator.isEmail(_controller.text)) {
      setState(() {
        isEmail = true;
      });
    } else {
      setState(() {
        isEmail = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(handlePasswordField);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(handlePasswordField);
    _controller.dispose();
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
            key: signupForm,
            child: Column(
              children: [
                InputField(
                  controller: _controller,
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
                  hintText: "Email or Mobile Number",
                ),
                SizedBox(
                  height: 20,
                ),
                (isEmail)
                    ? InputField(
                        controller: _passwordController,
                        hintText: "Password",
                        isPassword: true,
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
                SigninWithGoogle(text: "Signup With Google", onTap: () {}),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  text: (!isEmail) ? "Send OTP" : "Next",
                  onTap: () async {
                    if (signupForm.currentState!.validate()) {
                      if (Validator.isEmail(_controller.text)) {
                        auth
                            .signupWithEmailPassword(_controller.text.trim(),
                                _passwordController.text.trim(), auth.userType!)
                            .catchError(handleError)
                            .then((value) {
                          FostrRouter.goto(context, Routes.addDetails);
                        });
                      } else if (Validator.isPhone(_controller.text)) {
                        if (!auth.isLoading) {
                          auth
                              .signInWithPhone(context, _controller.text)
                              .then((value) {
                            FostrRouter.goto(context, Routes.otpVerification);
                          }).catchError(handleError);
                        }
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
                      "Have an account?  ",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FostrRouter.pop(context);
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
    ));
  }

  FutureOr<Null> handleError(Object error) async {
    setState(() {
      isError = true;
      this.error = showAuthError(error.toString());
    });
    signupForm.currentState!.validate();
  }
}
