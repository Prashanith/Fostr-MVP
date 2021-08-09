import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuizInfoTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subTitle;
  const QuizInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(130, 130, 130, 1),
          ),
          child: icon,
        ),
        title: Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "Lato",
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(130, 130, 130, 1),
            ),
          ),
        ),
        subtitle: Flexible(
          child: Text(
            subTitle,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: "Lato",
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(153, 153, 153, 1),
            ),
          ),
        ),
      ),
    );
  }
}
