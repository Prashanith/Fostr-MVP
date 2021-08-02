import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class Background extends StatelessWidget with FostrTheme {
  final bool withImage;
  Background({Key? key, this.withImage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: background,
      ),
    );
  }
}
