import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/Minimal.dart';
import 'package:fostr/pages/rooms/ThemePage.dart';
import 'package:fostr/pages/user/CalendarPage.dart';
import 'package:fostr/pages/user/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/rooms/OngoingRoomCard.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'SearchPage.dart';

class OngoingRoom extends StatefulWidget {
  const OngoingRoom({Key? key}) : super(key: key);

  @override
  State<OngoingRoom> createState() => _OngoingRoomState();
}

class _OngoingRoomState extends State<OngoingRoom> with FostrTheme {
  int _selectedIndex = 0;
  PageController controller = PageController(initialPage: 0);

  final List<Widget> _children = [
    HomePage(),
    SearchPage(),
    CalendarPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    // final user = auth.user!;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: gradientBottom, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              activeColor: Color(0xff94B5AC),
              color: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 300),
              tabBackgroundColor: Colors.white,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                ),
                GButton(
                  icon: LineIcons.search,
                ),
                GButton(
                  icon: LineIcons.calendar,
                ),
                GButton(
                  icon: LineIcons.user,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  controller.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                });
              }),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: secondaryBackground),
        child: PageView(
          controller: controller,
          physics: BouncingScrollPhysics(),
          children: _children,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with FostrTheme {
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now()) +
      " " +
      DateFormat.Hm().format(DateTime.now());
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    askPermission();
    super.initState();
  }

  askPermission() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  /// Method for refreshing list

  void _onRefresh() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.refreshCompleted();
  }

  /// Method for loading list

  void _onLoading() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Container(
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
                      // SvgPicture.asset(ICONS + "menu.svg"),
                      // SizedBox(
                      //   height: 20,
                      // ),
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
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(32),
                        topEnd: Radius.circular(32),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: roomCollection.snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                print(snapshot.data!.docs[0].id);
                                return StreamBuilder<QuerySnapshot>(
                                  stream: roomCollection.doc(snapshot.data!.docs[0].id).collection("rooms").snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    // Handling errors from firebase
                                    if (snapshot.hasError)
                                      return Center(child: Text('Error: ${snapshot.error}'));
                              
                                    if (snapshot.hasData && snapshot.data!.docs.length == 0)
                                      return Center(child: Text('No Ongoing Rooms Yet'));
                              
                                    return snapshot.hasData
                                      ? SizedBox(
                                        height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*0.24,
                                        child: SmartRefresher(
                                          enablePullDown: true,
                                          controller: _refreshController,
                                          onRefresh: _onRefresh,
                                          onLoading: _onLoading,
                                          child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ThemePage(room: Room.fromJson(document))));
                                                },
                                                child: OngoingRoomCard(room: Room.fromJson(document))
                                                // child: Column(
                                                //   children: [
                                                //     Text(document.id.toString()),
                                                //   ],
                                                // ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                      // Display if still loading data
                                      : Center(child: CircularProgressIndicator());
                                  },
                                );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: startRoomButton()),
          ],
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
          FostrRouter.goto(context, Routes.clubRoomDetails);
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
