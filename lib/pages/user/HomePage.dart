import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/RoomDetails.dart';
import 'package:fostr/pages/rooms/ThemePage.dart';
import 'package:fostr/pages/user/CalendarPage.dart';
import 'package:fostr/pages/user/UserProfile.dart';
import 'package:fostr/pages/user/custom_animated_bottom_bar.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/services/MethodeChannels.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/utils/widget_constants.dart';
import 'package:fostr/widgets/rooms/OngoingRoomCard.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SearchPage.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with FostrTheme {
  int _currentindex = 2;
  final List<Widget> _children = [
    OngoingRoom(),
    RoomDetails(),
    SearchPage(),
    UserProfilePage(),
  ];

  final AgoraChannel agoraChannel = GetIt.I<AgoraChannel>();

  static const textStyle = TextStyle(fontSize: 16, color: Colors.black87);
  Future<void> routeTo(param) async {
    switch (param) {
      case 'home':
        setState(() {
          _currentindex = 0;
        });
        Navigator.of(context).pop();
        break;
      case 'notify':
        setState(() {
          _currentindex = 0;
        });
        Navigator.of(context).pop();
        // FostrRouter.goto(
        //   context,
        //   Routes.notifications,
        // );
        break;
      case 'about':
        setState(() {
          _currentindex = 0;
        });
        if (await canLaunch("url")) {
          await launch(
            "url",
            forceSafariVC: true,
            forceWebView: true,
            enableJavaScript: true,
            headers: <String, String>{'my_header_key': 'my_header_value'},
          );
          print("c");
        } else {
          Fluttertoast.showToast(
              msg: "Could not launch URL",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }
        Navigator.of(context).pop();
        break;
      case 'fostrpoints':
        setState(() {
          _currentindex = 3;
        });
        Navigator.of(context).pop();
        break;
      case 'contactus':
        setState(() {
          _currentindex = 0;
        });
        if (await canLaunch("url")) {
          await launch(
            "url",
            forceSafariVC: false,
            forceWebView: false,
            headers: <String, String>{'my_header_key': 'my_header_value'},
          );
        } else {
          Fluttertoast.showToast(
              msg: "Could not launch URL",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }
        Navigator.of(context).pop();
        break;
      case 'shareApp':
        setState(() {
          _currentindex = 0;
        });
        QuerySnapshot x =await FirebaseFirestore.instance.collection("links").get();
        print(x.docs[0]["appLink"]);
        try{
          // await Share.share(x.docs[0]["appLink"]);
        }catch(e){
          print(e);
          Fluttertoast.showToast(
              msg: "Unable to share",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0
          );
        }

        Navigator.of(context).pop();
        break;
    }
  }


  @override
  void initState() {
    super.initState();
    agoraChannel.setAgoraUserId("haha", "myroom", "user", "4");
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    // final user = auth.user!;
    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: UserAccountsDrawerHeader(
                  accountEmail: null,
                  accountName: null,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain)),
                ),
              ),
              ListTile(
                title: Text(
                    'Welcome back,',
                    style:TextStyle(
                      fontSize:24,
                        color: Color(0xffFF613A)
                    )
                ),
                // subtitle: Text(
                //     'Welcome back',
                //     style:TextStyle(
                //       color: Color(0xffFF613A)
                //     )
                // ),
              ),
              ListTile(
                leading: const Text('Home', style: textStyle),
                onTap: () => routeTo('home'),
              ),
              // ListTile(
              //   leading: const Text('Notifications', style: textStyle),
              //   onTap: () => routeTo('notify'),
              // ),
              ListTile(
                leading: const Text('About us', style: textStyle),
                onTap: () => routeTo('about'),
              ),
              // ListTile(
              //   leading: const Text('Fostr Points', style: textStyle),
              //   onTap: () => routeTo('fostrpoints'),
              // ),
              ListTile(
                leading: const Text('Contact us', style: textStyle),
                onTap: () => routeTo('contactus'),
              ),
              // ListTile(
              //   leading: const Text('Share App', style: textStyle),
              //   onTap: () => routeTo('shareApp'),
              // ),
              ListTile(
                leading: const Text('Logout', style: textStyle),
                onTap: () async {
                  setState(() {
                    _currentindex = 0;
                  });
                  Navigator.of(context).pop();
                  await auth.signOut();
                  FostrRouter.removeUntillAndGoto(
                    context,
                    Routes.login,
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar:AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                color: Colors.black,
                height: 20,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        toolbarHeight: 65,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: Center(
                child: Image(
                  height: 40,
                    image:AssetImage('assets/images/logo.png',)),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: _children[_currentindex],
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xff2A9D8F),
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     showGeneralDialog(
      //       barrierLabel: "Label",
      //       barrierColor: Colors.black.withOpacity(0.5),
      //       transitionDuration: Duration(milliseconds: 400),
      //       context: context,
      //       pageBuilder: (context, anim1, anim2) {
      //         return Align(
      //             alignment: Alignment.center,
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.all(Radius.circular(20)),
      //               child: Container(
      //                 height: MediaQuery.of(context).size.height * 0.8,
      //                 width: MediaQuery.of(context).size.width * 0.94,
      //                 child: RoomDetails(),
      //               ),
      //             ));
      //       },
      //       transitionBuilder: (context, anim1, anim2, child) {
      //         return SlideTransition(
      //           position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
      //               .animate(anim1),
      //           child: child,
      //         );
      //       },
      //     );
      //   },
      // ),
      bottomNavigationBar: CustomAnimatedBottomBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentindex,
        // height: min(MediaQuery.of(context).size.height * 0.075, 75),
        // index: _currentindex,
        //
        // items: <Widget>[
        //   Icon(
        //     Icons.home,
        //     size: 17,
        //   ),
        //   Icon(
        //     LineIcons.plus,
        //     size: 17,
        //   ),
        //   Icon(
        //     LineIcons.search,
        //     size: 17,
        //   ),
        //   Icon(
        //     LineIcons.user,
        //     size: 17,
        //   ),
        // ],
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            inactiveColor: Colors.black,
            activeColor: GlobalColors.signUpSignInButton,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text('Rooms'),
            inactiveColor: Colors.black,
            activeColor: GlobalColors.signUpSignInButton,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Search ',
            ),
            inactiveColor: Colors.black,
            activeColor: GlobalColors.signUpSignInButton,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(

            icon: Icon(Icons.person),
            title: Text('Profile'),

            activeColor: GlobalColors.signUpSignInButton,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
        onItemSelected: (int value) { setState(() {
        _currentindex = value;
      }); },
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
    await Permission.microphone.request().then(
          (value) => Permission.storage.request(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment(-0.6, -1),
        //     end: Alignment(1, 0.6),
        //     colors: [
        //       Color.fromRGBO(148, 181, 172, 1),
        //       Color.fromRGBO(229, 229, 229, 1),
        //     ],
        //   ),
        // ),
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
                        (auth.userType == UserType.CLUBOWNER)
                            ? (user.bookClubName == "" ||
                                    user.bookClubName == null)
                                ? Text(
                                    "Hello, ${user.userName}",
                                    style: h1.apply(color: Colors.black),
                                  )
                                : Text(
                                    "Hello, ${user.bookClubName}",
                                    style: h1.apply(color: Colors.black),
                                  )
                            : (user.name.isEmpty)
                                ? Text(
                                    "Hello, ${user.userName}",
                                    style: h1.apply(color: Colors.black),
                                  )
                                : Text(
                                    "Hello, ${user.name}",
                                    style: h1.apply(color: Colors.black),
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
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: Image.asset(IMAGES + "background.png").image,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   borderRadius: BorderRadiusDirectional.only(
                      //     topStart: Radius.circular(32),
                      //     topEnd: Radius.circular(32),
                      //   ),
                      //   color: Colors.white,
                      // ),
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
                              print(docs[0].id);
                              return ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final id = docs[index].id;
                                  return RoomList(id: id);
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
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

class RoomList extends StatelessWidget with FostrTheme {
  RoomList({
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
          return SizedBox.shrink();

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
                  child: (DateTime.parse(
                                  Room.fromJson(room).dateTime.toString())
                              .isAfter(DateTime.now()
                                  .subtract(Duration(minutes: 90))) &&
                          DateTime.parse(
                                  Room.fromJson(room).dateTime.toString())
                              .isBefore(
                                  DateTime.now().add(Duration(minutes: 10))))
                      ? OngoingRoomCard(
                          room: Room.fromJson(room),
                        )
                      : Container(),
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
