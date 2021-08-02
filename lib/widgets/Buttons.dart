import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class PrimaryButton extends StatelessWidget with FostrTheme {
  final String text;
  final VoidCallback onTap;

  PrimaryButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 330,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: buttonBorderRadius,
          gradient: primaryButton,
        ),
        child: Text(
          text,
          style: actionTextStyle,
        ),
      ),
    );
  }
}
