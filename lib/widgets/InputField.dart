import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onChange;
  InputField(
      {Key? key,
      this.hintText = "",
      this.keyboardType = TextInputType.text,
      this.validator,
      this.controller,
      this.onChange,
      this.isPassword = false})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with FostrTheme {
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        showPassword = widget.isPassword;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 61,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: boxShadow,
            ),
          ),
          TextFormField(
            onChanged: (e) {
              if (widget.onChange != null) {
                widget.onChange!();
              }
            },
            controller: widget.controller,
            validator: widget.validator,
            obscureText: showPassword,
            keyboardType: widget.keyboardType,
            cursorColor: textFieldStyle.color,
            style: textFieldStyle,
            decoration: InputDecoration(
              suffixIcon: (widget.isPassword)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: (showPassword)
                          ? Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Colors.white,
                            ),
                    )
                  : null,
              errorStyle: h2.apply(
                color: Colors.red,
              ),
              hintText: widget.hintText,
              hintStyle: textFieldStyle,
              fillColor: Color.fromRGBO(102, 163, 153, 1),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
