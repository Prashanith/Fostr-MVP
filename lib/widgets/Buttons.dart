import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;

  PrimaryButton({Key? key, required this.text, required this.onTap, this.width})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with FostrTheme {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (e) {
        setState(() {
          scale = 0.8;
        });
      },
      onTapUp: (e) {
        setState(() {
          scale = 1;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Transform.scale(scale: scale).transform,
        duration: Duration(milliseconds: 200),
        alignment: Alignment.center,
        width: (widget.width) ?? 330,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: buttonBorderRadius,
          gradient: primaryButton,
        ),
        child: Text(
          widget.text,
          style: actionTextStyle,
        ),
      ),
    );
  }
}
