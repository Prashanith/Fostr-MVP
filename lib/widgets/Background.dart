import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class Background extends StatelessWidget with FostrTheme {
  final bool withImage;
  final Gradient? gradient;
  Background({Key? key, this.withImage = false, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (gradient != null)
        ? Container(
            height: double.infinity,
            width: double.infinity,

          )
        : Container(
            height: double.infinity,
            width: double.infinity,

          );
  }
}
