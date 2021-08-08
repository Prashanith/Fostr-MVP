import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:fostr/widgets/rooms/DrageProfile.dart';

class CafeRoomScreen extends StatefulWidget {
  const CafeRoomScreen({Key? key}) : super(key: key);

  @override
  _CafeRoomScreenState createState() => _CafeRoomScreenState();
}

class _CafeRoomScreenState extends State<CafeRoomScreen> {
  int data = 42;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe9ffee),
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              DateTime.now().toString(),
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Spacer(),
            GestureDetector(
              child: RoundedImage(
                path: IMAGES + "profile.png",
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      // backgroundColor: Color(0xffe9ffee),
      body: body(size.width, size.height),
    );
  }

  final container = GlobalKey();

  Widget body(double width, double height) {
    return Container(
      key: container,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.asset(IMAGES + "cafe-main.png").image,
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          StreamBuilder(
              stream:
                  Stream.fromIterable(List.generate(data, (index) => index)),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  var map = List.generate(snapshot.data!, (idx) => idx);
                  print(map.length);
                  return Stack(
                    children: [
                      DragProfile(offset: Offset(010, 240), isSpeaker: true),
                      map.length >= 2
                          ? DragProfile(
                              offset: Offset(85, 225), isSpeaker: true)
                          : Container(),
                      map.length >= 3
                          ? DragProfile(
                              offset: Offset(30, 320), isSpeaker: true)
                          : Container(),
                      map.length >= 4
                          ? DragProfile(
                              offset: Offset(160, 330), isSpeaker: true)
                          : Container(),
                      map.length >= 5
                          ? DragProfile(
                              offset: Offset(245, 290), isSpeaker: true)
                          : Container(),
                      map.length >= 6
                          ? DragProfile(
                              offset: Offset(240, 225), isSpeaker: true)
                          : Container(),
                      map.length >= 7
                          ? DragProfile(
                              offset: Offset(190, 210), isSpeaker: true)
                          : Container(),
                      // map.length == 8
                      //   ? DragProfile(offset: Offset(210, 215), user: OldUser.fromJson(map[7]), isSpeaker: true)
                      //   : Container(),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          bottom(context),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }

  Widget bottom(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          RoundedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.blueGrey,
            child: Text(
              'Leave quietly',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
