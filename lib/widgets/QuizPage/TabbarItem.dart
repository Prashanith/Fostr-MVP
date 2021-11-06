import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class TabbarItem extends StatelessWidget {
  final int index;
  final int currentIndex;

  const TabbarItem({Key? key, required this.index, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 7.h,
      width: 7.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (index == currentIndex + 1)
            ? Color.fromRGBO(99, 156, 143, 1)
            : Color(0xffd4d4d4),
      ),
      child: Text(
        index.toString(),
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
