import 'package:flutter/material.dart';
import 'package:fostr/pages/clubOwner/CreateRoom.dart';
import 'package:fostr/pages/user/CalendarPage.dart';
import 'package:fostr/pages/user/SearchPage.dart';
import 'package:fostr/pages/user/UserProfile.dart';

import 'package:fostr/utils/theme.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  static final String id = "Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  PageController controller = PageController(initialPage: 0);

  final List<Widget> _children = [
    CreateRoom(),
    SearchPage(),
    CalendarPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: gradientTop,
      //   leading: Icon(Icons.menu, color: Colors.black),
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //         icon: Icon(Icons.settings_outlined, color: Colors.black),
      //         onPressed: () {
      //           // Navigator.pushNamed(context, Settings.id);
      //         }),
      //     IconButton(
      //         icon: Icon(Icons.more_vert_outlined, color: Colors.black),
      //         onPressed: () {}),
      //   ],
      // ),
      body: PageView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        children: _children,
      ),
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
            duration: Duration(milliseconds: 800),
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
            },
          ),
        ),
      ),
    );
  }
}
