import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:sizer/sizer.dart';

class QuizContainer extends StatefulWidget {
  QuizContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<QuizContainer> createState() => _QuizContainerState();
}

class _QuizContainerState extends State<QuizContainer> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FostrRouter.goto(context, Routes.quizIntro);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 90.w,
        height: 105,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: Color(0xff7AB198),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 16,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(IMAGES + "quiz.png"),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Text(
                "Reading Personality Quiz",
                style: h1.copyWith(
                  color: Color(0xff7BB299),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
