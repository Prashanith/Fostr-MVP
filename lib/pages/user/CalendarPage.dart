import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

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
              width: 90.w,
              decoration: BoxDecoration(
                boxShadow: boxShadow,
                color: Color(0xffEBFFEE),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(primary: h2.color!),
                ),
                child: DefaultTextStyle.merge(
                  style: h1.copyWith(fontSize: 18.sp),
                  child: CalendarDatePicker(
                    firstDate: DateTime(2000),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    onDateChanged: (DateTime value) {
                      print("object");
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: roomCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> outerData) {
                  if (outerData.hasData) {
                    final docs = outerData.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final id = docs[index].id;
                        if (auth.user?.followings != null &&
                            auth.user!.followings!.contains(id))
                          return RoomWidget(id: id);
                        return Container();
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: roomCollection.doc(id).collection('rooms').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length == 0)
          return Container();

        if (snapshot.hasData) {
          final roomList = snapshot.data!.docs;

          return Column(
            children: List.generate(
              roomList.length,
              (index) {
                final room = Room.fromJson(roomList[index].data());
                return GestureDetector(
                    onTap: () async {},
                    child: EventCard(
                      room: room,
                    ));
              },
            ).toList(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget with FostrTheme {
  final Room room;
  EventCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = room.dateTime?.substring(0, 10) ?? "";
    final time = room.dateTime?.substring(11, 16) ?? "";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      child: ListTile(
        title: Text(
          room.title ?? "",
          style: h1.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "@${room.roomCreator ?? ' '}",
          style: h1.copyWith(
            fontSize: 13.sp,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: h1.copyWith(
                fontSize: 11.sp,
              ),
            ),
            Text(
              date,
              style: h1.copyWith(
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
