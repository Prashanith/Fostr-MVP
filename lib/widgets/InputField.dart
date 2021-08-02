import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class InputField extends StatelessWidget with FostrTheme {
  final String hintText;
  InputField({Key? key, this.hintText = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        cursorColor: textFieldStyle.color,
        style: textFieldStyle,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textFieldStyle,
          fillColor: Color.fromRGBO(102, 163, 153, 1),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
        ),
      ),
    );
  }
}
