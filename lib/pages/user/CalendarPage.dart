import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:sizer/sizer.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Calendar:",
                  style: h1,
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20),
              height: 35.h,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: boxShadow,
                color: Color(0xffEBFFEE),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(primary: h2.color!),
                ),
                child: CalendarDatePicker(
                  firstDate: DateTime(2000),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  onDateChanged: (DateTime value) {},
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    EventCard(),
                    EventCard(),
                    EventCard(),
                    EventCard(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget with FostrTheme {
  EventCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      constraints: BoxConstraints(
        minHeight: 65,
        maxHeight: 90,
      ),
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: Color(0xffEBFFEE),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 16,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "10:00 a.m. :",
            style: h1.copyWith(
              fontSize: 13.sp,
            ),
          ),
          Flexible(
            child: Text(
              "Robin Sharma Book Reading",
              style: h1.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
