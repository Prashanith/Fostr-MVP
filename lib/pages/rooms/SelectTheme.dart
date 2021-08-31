import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/rooms/Cafe.dart';
import 'package:fostr/pages/rooms/Fun.dart';
import 'package:fostr/pages/rooms/Library.dart';
import 'package:fostr/pages/rooms/Minimal.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:provider/provider.dart';

class SelectTheme extends StatefulWidget {
  final Room room;
  SelectTheme({required this.room});

  @override
  _SelectThemeState createState() => _SelectThemeState();
}

class _SelectThemeState extends State<SelectTheme> {
  String roomTheme = "Minimalist", userKind = "participant";
  String img = "minimalistbg.png";
  int speakersCount = 0, participantsCount = 0;
  ClientRole role = ClientRole.Audience;
  bool isLoading = false;
  String msg = 'Participants can only listen :)';
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? roomStream;
  @override
  void initState() {
    initRoom();
    super.initState();
  }
  @override
  void dispose() {
    roomStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Scaffold(
      body: Material(
        color: gradientBottom,
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: Image.asset(IMAGES + "logo.png")),
                Text('You can join a room either as: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal.shade800,
                      fontFamily: "Lato",
                    )),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            userKind = "participant";
                            role = ClientRole.Audience;
                            msg = 'Participants can only listen :)';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(
                            20,
                          ),
                          decoration: BoxDecoration(
                            color: userKind == "participant"
                                ? gradientBottom
                                : gradientTop,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Participant",
                            style: TextStyle(
                              color: userKind == "participant"
                                  ? Colors.white
                                  : Colors.teal.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    (speakersCount < 8)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xB2476747),
                                  fontFamily: "Lato",
                                )),
                          )
                        : Container(),
                    (speakersCount < 8)
                        ? Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  userKind = "speaker";
                                  role = ClientRole.Broadcaster;
                                  msg = 'Only Speakers can talk :)';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  color: userKind == "speaker"
                                      ? gradientBottom
                                      : gradientTop,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "Speaker",
                                  style: TextStyle(
                                    color: userKind == "speaker"
                                        ? Colors.white
                                        : Colors.teal.shade800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '$msg',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.teal.shade800),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Participants: $participantsCount",
                    style: TextStyle(
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Speakers: $speakersCount",
                    style: TextStyle(
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.teal.shade500,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text('Join Room'),
                        onPressed: () async {
                          await updateRoom(user);
                          navigateToRoom();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff94B5AC)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Maximum of 8 Speakers are allowed...",
                    style: TextStyle(
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  initRoom() async {
    // get the details of room
    roomStream = roomCollection
        .doc(widget.room.id)
        .collection("rooms")
        .doc(widget.room.title)
        .snapshots()
        .listen((result) {
      print(result.data()!['speakersCount']);
      setState(() {
        participantsCount = (result.data()!['participantsCount'] < 0
            ? 0
            : result.data()!['participantsCount']);
        speakersCount = (result.data()!['speakersCount'] < 0
            ? 0
            : result.data()!['speakersCount']);
        token = result.data()!['token'];
        channelName = widget.room.title!;
      });
      print("set");
    });
  }

  updateRoom(User user) async {
    setState(() {
      isLoading = true;
    });

    if (userKind == "speaker") {
      // update the list of speakers
      var rawSpeakers = await roomCollection
          .doc(widget.room.id)
          .collection("rooms")
          .doc(widget.room.title)
          .collection("speakers")
          .get();
      var speakers = rawSpeakers.docs.map((e) => e.data()).toList();
      bool isThere = false;
      speakers.forEach((element) {
        if (element['id'] == user.id && !isThere) {
          isThere = true;
        }
      });
      if (!isThere) {
        await roomCollection
            .doc(widget.room.id)
            .collection("rooms")
            .doc(widget.room.title)
            .update({
          'speakersCount': speakersCount + 1,
        });
        await roomCollection
            .doc(widget.room.id)
            .collection("rooms")
            .doc(widget.room.title)
            .collection("speakers")
            .doc(user.userName)
            .set(user.toJson());
        setState(() {
          speakersCount = speakers.length + 1;
        });
      }
    } else {
      // update the list of participants
      var rawParticipants = await roomCollection
          .doc(widget.room.id)
          .collection("rooms")
          .doc(widget.room.title)
          .collection("participants") // participants
          .get();
      var participants = rawParticipants.docs.map((e) => e.data()).toList();
      bool isThere = false;
      participants.forEach((element) {
        if (element['id'] == user.id && !isThere) {
          isThere = true;
        }
      });
      if (!isThere) {
        await roomCollection
            .doc(widget.room.id)
            .collection("rooms")
            .doc(widget.room.title)
            .update({
          'participantsCount': participantsCount + 1,
        });
        await roomCollection
            .doc(widget.room.id)
            .collection("rooms")
            .doc(widget.room.title)
            .collection("participants")
            .doc(user.userName)
            .set({
          'username': user.userName,
          'name': user.name,
          'profileImage': user.userProfile?.profileImage ?? "image",
        });
        setState(() {
          participantsCount = participants.length + 1;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  navigateToRoom() {
    // navigate to the room
    if (roomTheme == "Minimalist") {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => Scaffold(
                body: Minimal(
                      room: widget.room,
                      role: role,
                    ),
              )));
    } else if (roomTheme == "Cafe") {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => Cafe(
                    room: widget.room,
                    role: role,
                  )));
    } else if (roomTheme == "Library") {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => Library(
                    room: widget.room,
                    role: role,
                  )));
    } else if (roomTheme == "Fun") {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => Fun(
                    room: widget.room,
                    role: role,
                  )));
    }
  }
}
