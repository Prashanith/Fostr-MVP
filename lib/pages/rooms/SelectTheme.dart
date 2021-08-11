import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/rooms/Cafe.dart';
import 'package:fostr/pages/rooms/Kids.dart';
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

  @override
  void initState() {
    initRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Material(
      color: gradientBottom,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom]
          ),
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(32),
            topEnd: Radius.circular(32),
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        img = "minimalistbg.png";
                        roomTheme = "Minimalist";
                      }),
                      child: Container(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(IMAGES + "minimalist.png"),
                              fit: BoxFit.fill, 
                            ),
                            borderRadius: BorderRadius.circular(35),
                            //color: Colors.black38
                          ),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width*0.4,
                          //color: Colors.blue,
                          margin: EdgeInsets.all(15.0),
                          //color: Colors.black38
                          child: Text(
                            'Minimalist',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        img = "cafebg.png";
                        roomTheme = "Cafe";
                      }),
                      child: Container(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(IMAGES + "cafe.png"),
                              fit: BoxFit.fill, 
                            ),
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.pink[200]),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width*0.4,
                          //color: Colors.blue,
                          margin: EdgeInsets.all(15.0),
                          //color: Colors.black38
                          child: Text(
                            'Cafe',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>setState(() {
                        img = "librarybg.png";
                        roomTheme = "Library";
                      }),
                      child: Container(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(IMAGES + "library.png"),
                              fit: BoxFit.fill, 
                            ),
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.blue[200]),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height*0.15,
                          width: MediaQuery.of(context).size.width*0.4,
                          //color: Colors.blue,
                          margin: EdgeInsets.all(15.0),
                          //color: Colors.black38
                          child: Text(
                            'Library',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        img = "Kidsbg.png";
                        roomTheme = "Kids";
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage(IMAGES + "kids.png"),
                              fit: BoxFit.fill, 
                            ),
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.red[200]),
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width*0.4,
                        //color: Colors.blue,
                        margin: EdgeInsets.all(15.0),
                        //color: Colors.black38
                        child: Text(
                          'Kids',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                  image: new AssetImage(IMAGES + img),
                  fit: BoxFit.cover, 
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text('You can join room either as: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xB2476747),
                      fontFamily: "Lato",
                    )
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height:20),
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
                          padding: EdgeInsets.all(20,),
                          decoration: BoxDecoration(
                            color: userKind == "participant" ? gradientBottom : gradientTop,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Participant", style: TextStyle(
                            color: userKind == "participant" ? Colors.white : Colors.teal.shade800,
                            fontSize: 16,
                          ),),
                        ),
                      ),
                      ),
                      (speakersCount < 8)
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR", style: TextStyle(
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
                            padding: EdgeInsets.all(20,),
                            decoration: BoxDecoration(
                              color: userKind == "speaker" ? gradientBottom : gradientTop,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text("Speaker", style: TextStyle(
                              color: userKind == "speaker" ? Colors.white : Colors.teal.shade800,
                              fontSize: 16,
                            ),),
                          ),
                          ),
                        )
                      : Container()
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('$msg', 
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.teal.shade800
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Theme Selected: $roomTheme", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Participants: $participantsCount", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Speakers: $speakersCount", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  Divider(color: Colors.teal.shade500,),
                  isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text('Join Room'),
                        onPressed: () {
                          updateRoom(user);
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
                  SizedBox(height: MediaQuery.of(context).size.height*0.05)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  initRoom() async {
    // get the details of room
    roomCollection
      .doc(widget.room.id)
      .collection("rooms")
      .doc(widget.room.title)
      .snapshots()
      .listen((result) {
        print(result.data()!['speakersCount']);
        setState(() {
          participantsCount = result.data()!['participantsCount'];
          speakersCount = result.data()!['speakersCount'];
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

    if(userKind == "speaker") {
      // update the list of speakers
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
        .set({
          'username': user.userName,
          'name': user.name,
          'profileImage': user.userProfile?.profileImage ?? "image",
        });
    } else {
      // update the list of participants
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
    }

    navigateToRoom();
  }

  navigateToRoom() {
    // navigate to the room
    if(roomTheme == "Minimalist") {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) => Minimal(
          room: widget.room,
          role: role,
        ))
      );
    } else if(roomTheme == "Cafe") {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) => Cafe(
          room: widget.room,
          role: role,
        ))
      );
    } else if(roomTheme == "Library") {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) => Library(
          room: widget.room,
          role: role,
        ))
      );
    } else if(roomTheme == "Kids") {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) => Kids(
          room: widget.room,
          role: role,
        ))
      );
    }
  }

}