import 'package:flutter/material.dart';
import 'package:fostr/widgets/Background.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [Background(), child],
      ),
    );
  }
}
