import 'package:flutter/material.dart';
import 'package:fostr/models/QuestionModel/Question.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/QuizPage/QuizQuestion.dart';
import 'package:fostr/widgets/QuizPage/TabbarItem.dart';
import 'package:sizer/sizer.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz>
    with FostrTheme, SingleTickerProviderStateMixin {
  TabController? tabController;

  void updateIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    tabController!.addListener(updateIndex);
  }

  @override
  void dispose() {
    tabController!.removeListener(updateIndex);
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(229, 229, 229, 1),
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
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Flexible(
                      child: Text(
                        "Reading Personality Quiz",
                        style: h1.copyWith(
                          fontSize: 22.sp,
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
                    padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // padding: EdgeInsets.only(left: 10.w),
                          alignment: Alignment.center,
                          height: 8.h,
                          child: TabBar(
                            enableFeedback: true,
                            controller: tabController,
                            indicatorColor: Color.fromRGBO(99, 156, 143, 1),
                            physics: BouncingScrollPhysics(),
                            isScrollable: true,
                            tabs: List.generate(
                              7,
                              (idx) => TabbarItem(
                                index: idx + 1,
                                currentIndex: tabController!.index,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: List.generate(
                              7,
                              (index) => QuizQuestion(
                                question: QUESTIONS[index],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (tabController!.index > 0) {
                                    tabController!
                                        .animateTo(tabController!.index - 1);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 2),
                                  height: 9.h,
                                  width: 9.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(119, 175, 151, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (tabController!.index < 6) {
                                    tabController!
                                        .animateTo(tabController!.index + 1);
                                  } else if (tabController!.index == 6) {
                                    FostrRouter.replaceGoto(
                                        context, Routes.analyzingPage);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 2),
                                  height: 9.h,
                                  width: 9.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(178, 214, 195, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
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
