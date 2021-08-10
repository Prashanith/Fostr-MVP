import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CreateRoom extends StatefulWidget {
  static final String id = "CreateRoom";

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
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
                padding: paddingH + const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${user.userName}",
                      style: h1.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset(IMAGES + "background.png").image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(32),
                      topEnd: Radius.circular(32),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 40.w,
                              decoration: BoxDecoration(
                                boxShadow: boxShadow,
                                borderRadius: BorderRadius.circular(42),
                                color: Color(0xff96C5AE),
                              ),
                              child: Text(
                                "3000",
                                style: h1.copyWith(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "MEMBERS",
                              style: h1.copyWith(
                                color: Color(0xff96C5AE),
                                fontWeight: FontWeight.bold,
                                fontSize: 24.sp,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 40.h,
                          width: 90.w,
                          constraints: BoxConstraints(
                            maxWidth: 370,
                            maxHeight: 340,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(8, 0),
                                blurRadius: 16,
                                color: Colors.black.withOpacity(0.25),
                              )
                            ],
                            gradient: LinearGradient(colors: [
                              Color(0xff97C6AF),
                              Color(0xffC9DED0),
                            ]),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "TOP ROOMS",
                                  style: h2.copyWith(
                                      fontSize: 18.sp, color: Colors.white),
                                ),
                              ),
                              RoomLine(
                                width: 200,
                                bookName: "e-Habits Book Club",
                              ),
                              RoomLine(
                                width: 150,
                                bookName: "Science Reads",
                              ),
                              RoomLine(
                                width: 100,
                                bookName: "Sita",
                              ),
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

class RoomLine extends StatelessWidget with FostrTheme {
  RoomLine({Key? key, required this.width, required this.bookName})
      : super(key: key);
  final double width;
  final String bookName;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RoomBar(
          width: width,
          bookName: bookName,
        ),
        SizedBox(
          width: 2.w,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            (width * 4).toInt().toString(),
            style: h1.copyWith(color: Colors.white, fontSize: 22.sp),
          ),
        )
      ],
    );
  }
}

class RoomBar extends StatelessWidget with FostrTheme {
  RoomBar({Key? key, required this.width, required this.bookName})
      : super(key: key);

  final String bookName;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      height: 59,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(8, 0),
        //     blurRadius: 16,
        //     color: Colors.black.withOpacity(0.25),
        //   )
        // ],
        image: DecorationImage(
          image: Image.asset(IMAGES + "background.png").image,
          fit: BoxFit.cover,
        ),
      ),
      child: Flexible(
        child: Text(
          bookName,
          style: h1.copyWith(fontSize: 14.sp),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
