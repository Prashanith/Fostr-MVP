import 'package:flutter/material.dart';
import 'package:fostr/models/QuestionModel/Question.dart';
import 'package:fostr/utils/theme.dart';
import 'package:sizer/sizer.dart';

class QuizQuestion extends StatefulWidget {
  final Question question;

  const QuizQuestion({Key? key, required this.question}) : super(key: key);

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 3.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.question,
              style: h1.copyWith(
                fontSize: 18.sp,
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Column(
              children: List.generate(
                widget.question.options.length,
                (index) {
                  return buildOption(
                    String.fromCharCode(65 + index),
                    widget.question.options[index][0],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOption(String id, String option) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 8.h,
            width: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffd4d4d4),
            ),
            child: Flexible(
              child: Text(
                id,
                style: actionTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Text(
              option,
              style: actionTextStyle.copyWith(
                fontSize: 16.sp,
                color: Color(0xff333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
