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
  bool isEmail = false;
  bool isNumber = false;
  bool isError = false;
  String error = "";
  String countryCode = "+91";

  void handlePasswordField() {
    if (Validator.isEmail(idController.text)) {
      setState(() {
        isNumber = false;
        isEmail = true;
      });
    } else if (Validator.isPhone(idController.text)) {
      setState(() {
        isEmail = false;
        isNumber = true;
      });
    } else {
      setState(() {
        isEmail = false;
        isNumber = false;
      });
    }
  }

  void handleRoute(User? user) {
    if (user!.name.isEmpty || user.userName.isEmpty) {
      FostrRouter.goto(context, Routes.addDetails);
    } else {
      if (user.userType == UserType.USER) {
        FostrRouter.removeUntillAndGoto(
            context, Routes.userDashboard, (route) => false);
      } else if (user.userType == UserType.CLUBOWNER) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => Dashboard()), (route) => false);
      }
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
                    height: 14.h,
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
                          height: 2.h,
                        ),
                        (isEmail)
                            ? InputField(
                                maxLine: 1,
                                isPassword: true,
                                validator: (value) {
                                  if (passwordController.text.length < 6) {
                                    return "Password dose not match";
                                  }
                                },
                                controller: passwordController,
                                hintText: "Password",
                              )
                            : (isNumber)
                                ? Opacity(
                                    opacity: 0.6,
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(102, 163, 153, 1),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: boxShadow,
                                      ),
                                      child: CountryCodePicker(
                                        dialogSize: Size(350, 300),
                                        onChanged: (e) {
                                          setState(() {
                                            countryCode = e.dialCode.toString();
                                          });
                                        },
                                        initialSelection: 'IN',
                                        textStyle: actionTextStyle,
                                        // showCountryOnly: true,
                                        alignLeft: true,
                                      ),
                                    ),
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
                        (idController.text.isEmpty)
                            ? SigninWithGoogle(
                                text: "Login With Google",
                                onTap: () async {
                                  try {
                                    var user = await auth
                                        .signInWithGoogle(auth.userType!);
                                    if (user != null) {
                                      handleRoute(user);
                                    }
                                  } catch (e) {
                                    handleError(e);
                                  }
                                },
                              )
                            : SizedBox.shrink(),
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
                                  handleRoute(user);
                                } catch (e) {
                                  handleError(e);
                                }
                              } else if (Validator.isPhone(
                                      idController.text.trim()) &&
                                  !auth.isLoading) {
                                try {
                                  await auth.signInWithPhone(
                                      context,
                                      countryCode.trim() +
                                          idController.text.trim());

                                  FostrRouter.goto(
                                      context, Routes.otpVerification);
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
