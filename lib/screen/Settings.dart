import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/Theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/LightBtn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(229, 229, 229, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingH + const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Settings",
                      style: h1.apply(color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Settings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.asset(IMAGES + "background.png").image,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(32),
          topEnd: Radius.circular(32),
        ),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LightBtn(
                text: "Privacy Policy",
                url: "https://www.fostrreads.com/privacy"),
            LightBtn(
                text: "Terms and Conditions",
                url: "https://www.fostrreads.com/terms"),
            LightBtn(text: "About Us", url: "https://www.fostrreads.com/about"),
            LightBtn(
                text: "Contact Us", url: "https://www.fostrreads.com/contact"),
            SizedBox(height: 20.h),
            PrimaryButton(
              text: "Logout",
              onTap: () async {
                if (await confirm(
                  context,
                  title: Text('Warning ⚠️'),
                  content: Text("Are you sure you want to quit this amazing experience?"),
                  textOK: Text('Sadly Yes'),
                  textCancel: Text('Oh No!'),
                )) {
                  await auth.signOut();
                  FostrRouter.removeUntillAndGoto(
                    context,
                    Routes.userChoice,
                    (route) => false,
                  );
                }
                return;
              },
            ),
          ],
        ),
        
      ),
    );
  }
}
