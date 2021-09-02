import 'dart:async';
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/clubOwner/dashboard.dart';
import 'package:fostr/widgets/CheckboxFormField.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/Helpers.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/Loader.dart';
import 'package:fostr/widgets/SigninWithGoogle.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with FostrTheme {
  final signupForm = GlobalKey<FormState>();

  bool isError = false;
  bool isAgree = false;
  String error = "";

  TextEditingController _controller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Layout(
        child: Stack(
      children: [
        Padding(
          padding: paddingH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "Create New Account",
                  style: h1.copyWith(
                    fontSize: 22.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Please fill the form to continue",
                style: h2.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Form(
                key: signupForm,
                child: Column(
                  children: [
                    InputField(
                      onEditingCompleted: () {
                        FocusScope.of(context).nextFocus();
                      },
                      controller: _controller,
                      validator: (value) {
                        if (isError) {
                          isError = false;
                          return error;
                        }
                        if (value!.isEmpty) {
                          return "Enter your emai";
                        }
                        if (!Validator.isEmail(value)) {
                          return "Invalid Credentials";
                        }
                        return null;
                      },
                      hintText: "Enter your email",
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    InputField(
                      onEditingCompleted: () {
                        FocusScope.of(context).nextFocus();
                      },
                      maxLine: 1,
                      controller: _passwordController,
                      hintText: "Password",
                      isPassword: true,
                    ),
                    CheckboxFormField(
                      initialValue: false,
                      validator: (value) {
                        if (value != null && !value) {
                          return "You must agree to the terms and condition";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          isAgree = value ?? false;
                        });
                      },
                      title: Text(
                        "By registering you agree to the terms and conditions of this app.",
                        style: textFieldStyle.copyWith(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            FostrRouter.goto(context, Routes.signupWithMobile);
                          },
                          child: Text(
                            "Signup With Mobile Instead",
                            style: TextStyle(
                              fontFamily: "Lato",
                              color: Color(0xff476747),
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    SigninWithGoogle(
                        text: "Signup With Google",
                        onTap: () async {
                          try {
                            var user =
                                await auth.signInWithGoogle(auth.userType!);
                            if (user != null &&
                                user.createdOn == user.lastLogin) {
                              FostrRouter.goto(context, Routes.addDetails);
                            } else if (user != null) {
                              final isOk = await confirmDialog(context, h2);
                              if (isOk != null && isOk) {
                                if (auth.userType == UserType.USER) {
                                  FostrRouter.removeUntillAndGoto(context,
                                      Routes.userDashboard, (route) => false);
                                } else if (auth.userType ==
                                    UserType.CLUBOWNER) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                          builder: (_) => Dashboard()),
                                      (route) => false);
                                }
                              } else {
                                auth.signOut();
                              }
                            }
                          } catch (e) {
                            print(e);
                            handleError(e);
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      text: "Register",
                      onTap: () async {
                        if (signupForm.currentState!.validate()) {
                          if (Validator.isEmail(_controller.text)) {
                            try {
                              await auth.signupWithEmailPassword(
                                  _controller.text.trim(),
                                  _passwordController.text.trim(),
                                  auth.userType!);
                              FostrRouter.goto(context, Routes.addDetails);
                            } catch (error) {
                              handleError(error);
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
                            fontSize: 13.sp,
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
                              fontSize: 13.sp,
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
        ),
        Loader(
          isLoading: auth.isLoading,
        )
      ],
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

Future<bool?> confirmDialog(BuildContext context, TextStyle h2) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      return Container(
        height: size.height,
        width: size.width,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Align(
            alignment: Alignment(0, 0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: size.width * 0.9,
                constraints: BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'An account with this email already exists. Would you like to be signed in instead?',
                      style: h2.copyWith(
                        fontSize: 17.sp,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "CANCEL",
                            style: h2.copyWith(
                              fontSize: 17.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            "SIGN IN",
                            style: h2.copyWith(
                              fontSize: 17.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
