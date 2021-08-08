import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/Minimalist.dart';
import 'package:fostr/utils/theme.dart';

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
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom]
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
                              image: new AssetImage("assets/images/minimalist.png"),
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
                              image: new AssetImage("assets/images/cafe.png"),
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
                              image: new AssetImage("assets/images/library.png"),
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
                        img = "amphitheatrebg.png";
                        roomTheme = "Amphitheatre";
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage("assets/images/amphitheatre.png"),
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
                          'Amphitheatre',
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
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*5),
              decoration: BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                  image: new AssetImage("assets/images/" + img),
                  fit: BoxFit.cover, 
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),
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
                        ? SizedBox(width: 20)
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
                    // child: Text("Theme Selected: ", style: TextStyle(
                    child: Text("Theme Selected: $roomTheme", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    // child: Text("Participants: ", style: TextStyle(
                    child: Text("Participants: $participantsCount", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    // child: Text("Speakers: ", style: TextStyle(
                    child: Text("Speakers: $speakersCount", style: TextStyle(
                      color: Colors.teal.shade800, 
                    ),),
                  ),
                  Divider(color: Colors.teal.shade500,),
                  isLoading
                    ? CircularProgressIndicator()
                    : GestureDetector(
                      // onTap: () => updateRoom(),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width*0.4,
                        padding: EdgeInsets.all(20,),
                        decoration: BoxDecoration(
                          color: const Color(0xffa3c4bc),
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xffa3c4bc),
                              const Color(0xffe9ffee),
                            ],
                          ),
                        ),
                        child: Text("Join", style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 16,
                        ),),
                      ),
                    ),
                  SizedBox(height: 20,),
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

  updateRoom() async {
    setState(() {
      isLoading = true;
    });

    if(userKind == "speaker") {
      // update the list of speakers
      await roomCollection.doc(widget.room.dateTime).update({
        'speakersCount': speakersCount + 1,
      });
      await roomCollection.doc(widget.room.dateTime).collection("speakers").doc(profileData['username']).set({
        'username': profileData['username'],
        'name': profileData['name'],
        'profileImage': profileData['profileImage'],
      });
    } else {
      // update the list of participants
      await roomCollection.doc(widget.room.dateTime).update({
        'participantsCount': participantsCount + 1,
      });
      await roomCollection.doc(widget.room.dateTime).collection("participants").doc(profileData['username']).set({
        'username': profileData['username'],
        'name': profileData['name'],
        'profileImage': profileData['profileImage'],
      });
    }    

    navigateToRoom();
  }

  navigateToRoom() {
    // navigate to the room
    if(roomTheme == "Minimalist") {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Minimalist(
          room: widget.room,
          role: role,
        ))
      );
    }
    // else if(roomTheme == "Cafe") {
    //   Navigator.pushReplacement(context, MaterialPageRoute(
    //     builder: (context) => CafeRoomScreen(
    //       room: widget.room,
    //       role: role,
    //     ))
    //   );
    // } else if(roomTheme == "Library") {
    //   Navigator.pushReplacement(context, MaterialPageRoute(
    //     builder: (context) => LibraryRoomScreen(
    //       room: widget.room,
    //       role: role,
    //     ))
    //   );
    // }
  }

}