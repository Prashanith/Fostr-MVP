import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/Minimalist.dart';
import 'package:fostr/pages/user/profile.dart';

import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/user/OngoingRoomCard.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

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
    Container(),
    Container(),
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
              gap: 8,
              activeColor: Color(0xff94B5AC),
              color: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 800),
              tabBackgroundColor: Colors.white,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: 'Events',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
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
      body: PageView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        children: _children,
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
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      //   height: 30,
                      // ),
                      Text(
                        // "Hello, ${user.name} James",
                        "Hello,  James",
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          OngoingRoomCard(),
                          OngoingRoomCard(),
                          OngoingRoomCard(),
                          OngoingRoomCard(),
                          OngoingRoomCard(),
                          OngoingRoomCard(),
                          OngoingRoomCard(),
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
          _displayTextInputDialog(context);
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter your room name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  channelName = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  channelName = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Room name"),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('CANCEL', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  await _createChannel(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _createChannel(context) async {
    var roomToken = await getToken(channelName);
    // Add new data to Firestore collection
    await roomCollection.doc(channelName).set({
      'participantsCount': 0,
      'speakersCount': 1,
      'title': '$channelName',
      'roomCreator': profileData['username'],
      'token': roomToken.toString(),
    });
    await roomCollection
        .doc(channelName)
        .collection("speakers")
        .doc(profileData['username'])
        .set({
      'username': profileData['username'],
      'name': profileData['name'],
      'profileImage': profileData['profileImage'],
    }).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Minimalist(
            room: Room(
              title: '$channelName',
              // users: [myProfile],
              participantsCount: 1,
              roomCreator: profileData['username'],
              speakersCount: 1,
              token: roomToken.toString(),
            ),
            // Pass user role
            role: ClientRole.Broadcaster,
          ),
        ),
      ),
    );
  }
}
