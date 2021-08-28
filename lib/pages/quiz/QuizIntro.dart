import 'package:flutter/material.dart';

import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/QuizPage/QuizInfoTile.dart';
import 'package:sizer/sizer.dart';

class QuizIntro extends StatefulWidget {
  const QuizIntro({Key? key}) : super(key: key);

  @override
  State<QuizIntro> createState() => _QuizIntroState();
}

class _QuizIntroState extends State<QuizIntro> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        FostrRouter.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(
                      width: 2.h,
                    ),
                    Flexible(
                      child: Text(
                        "Reading Personality Quiz",
                        style: h1.copyWith(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(32),
                      topEnd: Radius.circular(32),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Tell us about your reading habits, and we’ll tell you which clubs to join!",
                            style: h1.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(51, 51, 51, 1),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Brief explanation about this quiz",
                            textAlign: TextAlign.left,
                            style: h2.copyWith(
                              fontSize: 14.sp,
                              color: Color(0xff625f5f),
                            ),
                          ),
                          SizedBox(
                            height: 0.h,
                          ),
                          Column(
                            children: [
                              QuizInfoTile(
                                icon: Icon(
                                  Icons.note_add,
                                  color: Colors.white,
                                ),
                                title: "7 Questions",
                                subTitle:
                                    "Quiz will have 7 questions related to reading",
                              ),
                              QuizInfoTile(
                                icon: Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                title: "Win a Medal",
                                subTitle:
                                    "Answer all questions to win a medal based on your reading habits",
                              ),
                              QuizInfoTile(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                                title: "Win a Medal",
                                subTitle:
                                    "Answer all questions to win a medal based on your reading habits",
                              ),
                            ],
                          ),
                          // Spacer(),
                          SizedBox(
                            height: 3.h,
                          ),
                          PrimaryButton(
                            text: "Start Quiz",
                            onTap: () {
                              FostrRouter.replaceGoto(context, Routes.quiz);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
