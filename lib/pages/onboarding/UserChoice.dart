import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:provider/provider.dart';

class UserChoice extends StatefulWidget {
  UserChoice({Key? key}) : super(key: key);

  @override
  State<UserChoice> createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Layout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
          ),
          Text(
            "Continue",
            style: h1.apply(fontSizeDelta: 15),
          ),
          SizedBox(
            height: 140,
          ),
          PrimaryButton(
              text: "As a User",
              onTap: () {
                auth.setUserType(UserType.USER);
                FostrRouter.goto(context, Routes.login);
              }),
          SizedBox(
            height: 40,
          ),
          PrimaryButton(
              text: "As a Club Owner",
              onTap: () {
                auth.setUserType(UserType.CLUBOWNER);
                FostrRouter.goto(context, Routes.login);
              }),
        ],
      ),
    );
  }
}
