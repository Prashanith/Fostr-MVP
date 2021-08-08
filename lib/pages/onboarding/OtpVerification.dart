import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/user/profile.dart';
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

import '../../widgets/Layout.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> with FostrTheme {
  final otpForm = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  bool isError = false;
  String error = "";

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
                  height: 140,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("Verification", style: h1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please enter the OTP",
                  style: h2,
                ),
                SizedBox(
                  height: 90,
                ),
                Form(
                  key: otpForm,
                  child: Column(
                    children: [
                      InputField(
                        validator: (value) {
                          if (isError) {
                            isError = false;
                            return error;
                          }
                          if (value!.length < 6) {
                            return "OTP should be 6 digits long";
                          } else if (!Validator.isNumber(value)) {
                            return "OTP should contain only digits";
                          }
                        },
                        controller: _controller,
                        hintText: "Enter OTP",
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 111),
                  child: PrimaryButton(
                    text: "Verify",
                    onTap: () async {
                      if (otpForm.currentState!.validate()) {
                        try {
                          await auth.verifyOtp(
                              context, _controller.text, auth.userType!);
                          if (auth.user!.createdOn == auth.user!.lastLogin) {
                            FostrRouter.goto(context, Routes.addDetails);
                          } else {
                            if (auth.userType == UserType.USER) {
                              FostrRouter.removeUntillAndGoto(context,
                                  Routes.ongoingRoom, (route) => false);
                            }
                          }
                        } catch (e) {
                          handleError(e);
                        }
                      }
                    },
                  ),
                ),
              ],
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
    otpForm.currentState!.validate();
  }
}
