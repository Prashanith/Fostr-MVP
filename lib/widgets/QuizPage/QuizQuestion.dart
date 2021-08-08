import 'package:flutter/material.dart';
import 'package:fostr/models/QuestionModel/Question.dart';
import 'package:fostr/utils/theme.dart';

class QuizQuestion extends StatefulWidget {
  final Question question;

  const QuizQuestion({Key? key, required this.question}) : super(key: key);

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
            style: h1.copyWith(
              fontSize: 20,
              color: Color.fromRGBO(51, 51, 51, 1),
            ),
          ),
          SizedBox(
            height: 30,
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
    );
  }

  Widget buildOption(String id, String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffd4d4d4),
            ),
            child: Text(
              id,
              style: actionTextStyle.copyWith(
                fontSize: 18,
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
                fontSize: 18,
                color: Color(0xff333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
