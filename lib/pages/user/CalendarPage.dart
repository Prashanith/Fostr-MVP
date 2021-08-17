import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with FostrTheme {
  DateTime date = DateTime.now();
  bool isEmpty = true;

  Future<List<Map<String, dynamic>>> getRooms(List<String> followings) async {
    List<Map<String, dynamic>> rooms = [];
    followings.forEach((id) async {
      await roomCollection.doc(id).collection('rooms').get().then((value) {
        final rawRooms = value.docs.map((e) => e.data()).toList();
        rooms.addAll(rawRooms);
      });
    });

    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
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
                      "Calendar",
                      style: h1.apply(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 2.h, horizontal: 20),
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
                                setState(() {
                                  date = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: getRooms(user?.followings ?? []),
                          initialData: [],
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.length == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No schedules currently",
                                    style: h2.copyWith(fontSize: 14.sp),
                                  ),
                                  Text(
                                    "You can follow some readers here",
                                    style: h2.copyWith(fontSize: 14.sp),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasData) {
                              var roomListData =
                                  snapshot.data!.where((element) {
                                final room = Room.fromJson(element);
                                return room.dateTime?.substring(0, 10) ==
                                    date.toString().substring(0, 10);
                              });
                              if (roomListData.length == 0) {
                                return Center(
                                  child: Text(
                                    "No schedules currently",
                                    style: h2.copyWith(fontSize: 14.sp),
                                  ),
                                );
                              }
                              return ListView(
                                children: roomListData.map(
                                  (element) {
                                    final room = Room.fromJson(element);

                                    return GestureDetector(
                                      onTap: () async {},
                                      child: EventCard(
                                        room: room,
                                      ),
                                    );
                                  },
                                ).toList(),
                              );
                            }
                            return Center(
                              child: Text(
                                "Getting fresh rooms",
                                style: h2.copyWith(fontSize: 14.sp),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

class RoomWidget extends StatelessWidget with FostrTheme {
  RoomWidget({
    Key? key,
    required this.id,
    required this.date,
  }) : super(key: key);

  final String id;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: roomCollection.doc(id).collection('rooms').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length == 0)
          return Container(
            child: Center(
              child: Text(
                "No Rooms Scheduled for today",
                style: h1,
                textAlign: TextAlign.center,
              ),
            ),
          );

        if (snapshot.hasData) {
          final roomList = snapshot.data!.docs;
          var roomListData = roomList.where((element) {
            final room = Room.fromJson(element.data());
            return room.dateTime?.substring(0, 10) ==
                date.toString().substring(0, 10);
          });
          return Column(
            children: roomListData.map(
              (element) {
                final room = Room.fromJson(element.data());
                if (room.dateTime?.substring(0, 10) ==
                    date.toString().substring(0, 10)) {
                  return GestureDetector(
                    onTap: () async {},
                    child: EventCard(
                      room: room,
                    ),
                  );
                }
                return Container(
                  child: Text("hello"),
                );
              },
            ).toList(),
          );
        }
        return Container();
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


// (user?.followings != null &&
//                                 user?.followings?.length != 0)
//                             ? ListView.builder(
//                                 itemCount: user?.followings?.length ?? 0,
//                                 itemBuilder: (context, index) {
//                                   print(user?.followings?.length);
//                                   return RoomWidget(
//                                     id: user!.followings![index],
//                                     date: date,
//                                   );
//                                 },
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "No schedules currently",
//                                       style: h1,
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10.0),
//                                       child: Text(
//                                         "You can follow some readers here",
//                                         style: h1,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),