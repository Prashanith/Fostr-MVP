import 'package:flutter/material.dart';

mixin FostrTheme {
  final paddingH = const EdgeInsets.symmetric(horizontal: 24);

  final primaryColor = Color(0xff66A399);
  static const gradientTop = Color(0xffe9ffee);
  static const gradientBottom = Color(0xffa3c4bc);
  static const btnGradientLeft = Color(0xff92c8a2);
  static const btnGradientRight = Color(0xff639c8f);
  static const cardGradientLeft = Color(0xff4a956f);
  static const cardGradientRight = Color(0xff8edaa9);

  final background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      gradientTop,
      gradientBottom,
    ],
  );

  final primaryButton = const LinearGradient(colors: [
    btnGradientLeft,
    btnGradientRight,
  ]);

  final buttonBorderRadius = BorderRadius.circular(20);

  final h1 = const TextStyle(
    fontSize: 24,
    color: Color(0xff476747),
    fontFamily: "Lato",
  );
  final h2 = const TextStyle(
    fontSize: 16,
    color: Color(0xB2476747),
    fontFamily: "Lato",
  );

  final textFieldStyle = const TextStyle(
    fontSize: 16,
    color: Color(0xffEEEEEE),
    fontFamily: "Lato",
  );

  final actionTextStyle = const TextStyle(
    fontSize: 16,
    color: Color(0xffffffff),
    fontFamily: "Lato",
  );

  final boxShadow = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 4,
      color: Colors.black.withOpacity(0.25),
    ),
  ];
}
