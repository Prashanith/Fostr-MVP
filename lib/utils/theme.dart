import 'package:flutter/material.dart';

mixin FostrTheme {
  final paddingH = const EdgeInsets.symmetric(horizontal: 24);

  final primaryColor = Color(0xff66A399);

  final background = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(176, 255, 193, 0.27),
      Color.fromRGBO(0, 91, 69, 0.36),
      // Color.fromRGBO(255, 255, 255, 1),
    ],
  );

  final primaryButton = const LinearGradient(colors: [
    Color.fromRGBO(146, 200, 162, 1),
    Color.fromRGBO(99, 156, 143, 1),
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
