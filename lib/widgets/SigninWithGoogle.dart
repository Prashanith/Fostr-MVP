import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';

class SigninWithGoogle extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const SigninWithGoogle({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  _SigninWithGoogleState createState() => _SigninWithGoogleState();
}

class _SigninWithGoogleState extends State<SigninWithGoogle> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        width: 330,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: buttonBorderRadius,
          color: Colors.white,
          // gradient: primaryButton,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: actionTextStyle.fontFamily,
            fontSize: actionTextStyle.fontSize,
          ),
        ),
      ),
    );
    ;
  }
}
