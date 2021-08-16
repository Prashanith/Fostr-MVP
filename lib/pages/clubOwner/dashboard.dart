import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fostr/pages/clubOwner/CreateRoom.dart';
import 'package:fostr/pages/rooms/ClubRoomDetails.dart';
import 'package:fostr/pages/user/CalendarPage.dart';
import 'package:fostr/pages/user/SearchPage.dart';
import 'package:fostr/pages/user/UserProfile.dart';
import 'package:fostr/utils/theme.dart';
import 'package:line_icons/line_icons.dart';

class Dashboard extends StatefulWidget {
  static final String id = "Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentindex = 2;
  final List<Widget> _children = [
    ClubRoomDetails(),
    CalendarPage(),
    CreateRoom(),
    // HomePage(),
    SearchPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentindex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: gradientBottom,
        height: MediaQuery.of(context).size.height * 0.075,
        index: _currentindex,
        items: <Widget>[
          Icon(
            LineIcons.plus,
            size: 20,
          ),
          Icon(
            LineIcons.calendar,
            size: 20,
          ),
          Icon(
            LineIcons.home,
            size: 20,
          ),
          Icon(
            LineIcons.search,
            size: 20,
          ),
          Icon(
            LineIcons.user,
            size: 20,
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
