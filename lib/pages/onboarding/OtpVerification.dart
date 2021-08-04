import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/SigninWithGoogle.dart';
import 'package:provider/provider.dart';

import 'Layout.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> with FostrTheme {
  TextEditingController _controller = TextEditingController();

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
              child: Column(
                children: [
                  InputField(
                    validator: (value) {},
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
                  if (_controller.text.length >= 6) {
                    await auth
                        .verifyOtp(context, _controller.text, auth.userType!)
                        .then((value) {
                      if (auth.user == null) {
                        FostrRouter.goto(context, Routes.addDetails);
                      } else {
                        print("done");
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
