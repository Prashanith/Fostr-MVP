import 'package:flutter/material.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class BookSuggestionPage extends StatefulWidget {
  const BookSuggestionPage({Key? key}) : super(key: key);

  @override
  State<BookSuggestionPage> createState() => _BookSuggestionPageState();
}

class _BookSuggestionPageState extends State<BookSuggestionPage>
    with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
                padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 0),
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
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(
                      width: 2.h,
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
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Congratulations, James! You are a part of",
                          textAlign: TextAlign.center,
                          style: h1.copyWith(
                            color: Color(0xff464646),
                            fontSize: 20.sp,
                          ),
                        ),
                        BookClubCard(),
                        BookClubCard(),
                        BookClubCard(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryButton(
                              text: "Retake Quiz",
                              onTap: () {
                                FostrRouter.pop(context);
                              },
                              width: 40.w,
                            ),
                            PrimaryButton(
                              text: "Go to Home",
                              onTap: () {
                                FostrRouter.removeUntillAndGoto(context,
                                    Routes.ongoingRoom, (route) => false);
                              },
                              width: 40.w,
                            ),
                          ],
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

class BookClubCard extends StatelessWidget with FostrTheme {
  BookClubCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 12.5.h,
        maxWidth: 80.w,
      ),
      width: 80.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Color(0xff639C8F),
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 16,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 13.h,
            width: 13.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1, -1),
                end: Alignment(1, 1),
                colors: [
                  Color(0xffB3D7DF),
                  Color(0xffCEC5DB),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 40.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 2.1.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "Doon Book Club",
                    overflow: TextOverflow.ellipsis,
                    style: h2.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "Reading A Farewell to Armsdddddddddddddddddddddddddddddddddddddd",
                    overflow: TextOverflow.ellipsis,
                    style: h2.copyWith(
                      color: Color(0xff595959),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
