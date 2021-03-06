import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';
import 'package:sizer/sizer.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final String? helperText;
  final int? maxLine;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final TextInputType keyboardType;
  final Function(String value)? onChange;
  final VoidCallback? onEditingCompleted;
  InputField({
    Key? key,
    this.hintText = "",
    this.helperText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.onChange,
    this.isPassword = false,
    this.maxLine = 1,
    this.onEditingCompleted,
  }) : super(
          key: key,
        );

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
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80.w,
              height: 8.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: boxShadow,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 90.w,
              child: TextFormField(
                onEditingComplete: widget.onEditingCompleted,
                maxLines: widget.maxLine ?? 1,
                onChanged: (e) {
                  if (widget.onChange != null) {
                    widget.onChange!(e);
                  }
                },
                controller: widget.controller,
                validator: widget.validator,
                obscureText: showPassword,
                keyboardType: widget.keyboardType,
                cursorColor: textFieldStyle.color,
                style: textFieldStyle.copyWith(
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.h, horizontal: 20),
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
                  errorStyle: h2.copyWith(color: Colors.red, fontSize: 14.sp),
                  hintText: widget.hintText,
                  hintStyle: textFieldStyle.copyWith(
                    fontSize: 14.sp,
                  ),
                  helperText: widget.helperText,
                  fillColor: Color.fromRGBO(102, 163, 153, 1),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
