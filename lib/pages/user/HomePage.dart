import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/Minimal.dart';
import 'package:fostr/pages/rooms/RoomDetails.dart';
import 'package:fostr/pages/rooms/ThemePage.dart';
import 'package:fostr/pages/user/CalendarPage.dart';
import 'package:fostr/pages/user/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/rooms/OngoingRoomCard.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'SearchPage.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with FostrTheme {
  int _currentindex = 2;
  final List<Widget> _children = [
    RoomDetails(),
    CalendarPage(),
    OngoingRoom(),
    SearchPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    // final user = auth.user!;
    return Scaffold(
      body: _children[_currentindex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: gradientBottom,
        height: MediaQuery.of(context).size.height * 0.075,
        index: _currentindex,
        items: <Widget>[
          Icon(
            LineIcons.plus,
            size: 18,
          ),
          Icon(
            LineIcons.calendar,
            size: 18,
          ),
          Icon(
            LineIcons.home,
            size: 18,
          ),
          Icon(
            LineIcons.search,
            size: 18,
          ),
          Icon(
            LineIcons.user,
            size: 18,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

class OngoingRoom extends StatefulWidget {
  const OngoingRoom({Key? key}) : super(key: key);

  @override
  State<OngoingRoom> createState() => _OngoingRoomState();
}

class _OngoingRoomState extends State<OngoingRoom> with FostrTheme {
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now()) +
      " " +
      DateFormat.Hm().format(DateTime.now());

  @override
  void initState() {
    askPermission();
    super.initState();
  }

  askPermission() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: paddingH + const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (user.name == "")
                            ? Text(
                                "Hello, User",
                                style: h1.apply(color: Colors.white),
                              )
                            : Text(
                                "Hello, ${user.name}",
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: roomCollection.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> outerData) {
                                  if (outerData.hasData) {
                                    final docs = outerData.data!.docs;

                                    return ListView.builder(
                                      itemCount: docs.length,
                                      itemBuilder: (context, index) {
                                        final id = docs[index].id;
                                        return RoomList(id: id);
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                      ),
                    ),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: startRoomButton(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget startRoomButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        child: Text('Start Room'),
        onPressed: () {
          FostrRouter.goto(context, Routes.roomDetails);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xff94B5AC)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

class RoomList extends StatelessWidget {
  const RoomList({
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
                final room = roomList[index].data();
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => ThemePage(
                          room: Room.fromJson(room),
                        ),
                      ),
                    );
                  },
                  child: (DateTime.parse(Room.fromJson(room).dateTime.toString()).isAfter(DateTime.now().subtract(Duration(minutes: 90)))
                        && DateTime.parse(Room.fromJson(room).dateTime.toString()).isBefore(DateTime.now().add(Duration(minutes: 10))))
                    ? OngoingRoomCard(
                      room: Room.fromJson(room),
                    )
                    : Container()
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
