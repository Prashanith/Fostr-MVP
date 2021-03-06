import 'dart:async';
import 'dart:developer';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/clubOwner/dashboard.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with FostrTheme {
  final loginForm = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isError = false;
  String error = "";

  void handleRoute(User? user, UserType userType) {
    if ((user!.name.isEmpty || user.userName.isEmpty) &&
        userType == UserType.USER) {
      FostrRouter.goto(context, Routes.addDetails);
    } else if (user.bookClubName != null &&
        (user.bookClubName!.isEmpty || user.userName.isEmpty) &&
        userType == UserType.CLUBOWNER) {
      FostrRouter.goto(context, Routes.addDetails);
    } else {
      if (userType == UserType.USER) {
        FostrRouter.removeUntillAndGoto(
            context, Routes.userDashboard, (route) => false);
      } else if (userType == UserType.CLUBOWNER) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => Dashboard()), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Layout(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
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
                      "Welcome Back!",
                      style: h1.copyWith(
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Please Login into your account ",
                    style: h2.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Form(
                    key: loginForm,
                    child: Column(
                      children: [
                        InputField(
                          onEditingCompleted: () {
                            FocusScope.of(context).nextFocus();
                          },
                          validator: (value) {
                            if (isError && error != "Wrong password") {
                              isError = false;
                              return error;
                            }
                            if (value!.isEmpty) {
                              return "enter your email";
                            }
                            if (!Validator.isEmail(value)) {
                              return "Invalid credential";
                            }
                            return null;
                          },
                          controller: idController,
                          hintText: "Enter your email",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        InputField(
                          maxLine: 1,
                          isPassword: true,
                          validator: (value) {
                            if (passwordController.text.length < 6) {
                              return "Password dose not match";
                            } else if (isError && error == "Wrong password") {
                              isError = false;
                              return error;
                            }
                          },
                          controller: passwordController,
                          hintText: "Password",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                FostrRouter.goto(
                                    context, Routes.loginWithMobile);
                              },
                              child: Text(
                                "Login With Mobile Instead",
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
                          text: "Login With Google",
                          onTap: () async {
                            try {
                              var user =
                                  await auth.signInWithGoogle(auth.userType!);
                              if (user != null) {
                                handleRoute(user, auth.userType!);
                              }
                            } catch (e) {
                              handleError(e);
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          text: "Login",
                          onTap: () async {
                            if (loginForm.currentState!.validate() &&
                                !auth.isLoading) {
                              if (Validator.isEmail(idController.text.trim())) {
                                try {
                                  var user = await auth.signInWithEmailPassword(
                                    idController.text.trim(),
                                    passwordController.text.trim(),
                                    auth.userType!,
                                  );
                                  handleRoute(user, auth.userType!);
                                } catch (e) {
                                  handleError(e);
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
                              "Don't have an account?  ",
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: Colors.white,
                                fontSize: 13.sp,
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
          ),
          Loader(
            isLoading: auth.isLoading,
          )
        ],
      ),
    );
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
