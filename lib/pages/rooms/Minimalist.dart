import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/Old.dart';
import 'package:fostr/widgets/UserProfile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Minimalist extends StatefulWidget {
  final Room room;
  final ClientRole role;
  const Minimalist({Key? key, required this.room, required this.role}) : super(key: key);

  @override
  _MinimalistState createState() => _MinimalistState();
}

class _MinimalistState extends State<Minimalist> {
  int speakersCount = 0, participantsCount = 0;
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  bool muted = false, isMicOn = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initRoom();
    // Initialize Agora SDK
    initialize();
  }

  @override
  void dispose() {
    // removeUser();
    // Destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  removeUser() async {
    if (widget.role == ClientRole.Broadcaster) {
      // update the list of speakers
      await roomCollection.doc(widget.room.dateTime).update({
        'speakersCount': speakersCount - 1,
      });
      await roomCollection
          .doc(widget.room.dateTime)
          .collection("speakers")
          .doc(profileData['username'])
          .delete();
    } else {
      // update the list of participants
      await roomCollection.doc(widget.room.dateTime).update({
        'participantsCount': participantsCount - 1,
      });
      await roomCollection
          .doc(widget.room.dateTime)
          .collection("participants")
          .doc(profileData['username'])
          .delete();
    }

    if ((participantsCount == 0 && speakersCount == 1) ||
        (participantsCount == 1 && speakersCount == 0)) {
      await roomCollection.doc(widget.room.dateTime).delete();
    }
  }

  /// Create Agora SDK instance and initialize
  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    print(channelName);
    // await getToken();
    print(token);
    print(baseUrl);
    print("got: " + widget.room.token.toString());
    // await _engine.joinChannel(hitoken, channelName, null, 0);
    await _engine.joinChannel(widget.room.token, channelName, null, 0);
    // await _engine.joinChannel(newToken, channelName, null, 0);
    // await _engine.joinChannel(newToken, channelName, null, 0);
    print("joined");
  }
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableAudio();
    await _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add Agora event handlers

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          print('onError: $code');
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannel: $channel, uid: $uid');
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined: $uid');
      },
      // tokenPrivilegeWillExpire: (token) async {
      //   await getToken();
      //   await _engine.renewToken(token);
      // },
    ));
  }

  void _onRefresh() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.room.title.toString(),
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed('/profile', arguments: myProfile),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: NetworkImage(myProfile.profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/minimalist-main.png"),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // list of speakers
          StreamBuilder(
              stream: roomCollection
                  .doc(widget.room.dateTime)
                  .collection('speakers')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Object?>> map = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: map.length,
                    padding: EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context, int index) {
                      return UserProfile(
                          user: OldUser.fromJson(map[index]),
                          size: 50,
                          isMute: false,
                          isSpeaker: true);
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),

          // // list of participants
          // StreamBuilder(
          //   stream: roomCollection.doc(widget.room.dateTime).collection('participants').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasData) {
          //       List<QueryDocumentSnapshot<Object>> map = snapshot.data.docs;
          //       return GridView.builder(
          //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          //         itemCount: map.length,
          //         padding: EdgeInsets.all(2.0),
          //         itemBuilder: (BuildContext context, int index) {
          //           return UserProfile(user: UserModel.fromJson(map[index]), size: 50, isMute: false, isSpeaker: false);
          //         },
          //       );
          //     } else {
          //       return CircularProgressIndicator();
          //     }
          //   }
          // ),

          // StreamBuilder<QuerySnapshot>(
          //   stream: roomCollection.doc(widget.room.dateTime).collection('speakers').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          //     return snapshot.hasData
          //       ? SmartRefresher(
          //       enablePullDown: true,
          //       controller: _refreshController,
          //       onRefresh: _onRefresh,
          //       onLoading: _onLoading,
          //       child: ListView(
          //         // children: [
          //         //   title(widget.room.dateTime),
          //         //   SizedBox(height: 30),
          //         //   speakers(
          //         //     widget.room.users.sublist(0, widget.room.participantsCount),
          //         //   ),
          //         //   others(
          //         //     widget.room.users.sublist(widget.room.participantsCount),
          //         //   ),
          //         // ],
          //         children: snapshot.data.docs.map((DocumentSnapshot document) {
          //           return UserProfile(user: UserModel.fromJson(document), size: 50, isMute: false, isSpeaker: true);
          //         }).toList(),
          //       ),
          //     )
          //     : CircularProgressIndicator();
          //   }
          // ),

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

  // Widget speakers(List<UserModel> users) {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: ScrollPhysics(),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //     ),
  //     itemCount: users.length,
  //     itemBuilder: (gc, index) {
  //       return UserProfile(
  //         user: users[index],
  //         isSpeaker: index == 0,
  //         isMute: false,
  //         size: 50,
  //       );
  //     },
  //   );
  // }

  // Widget others(List<UserModel> users) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Text(
  //           'Others in the room',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 15,
  //             color: Colors.grey.withOpacity(0.6),
  //           ),
  //         ),
  //       ),
  //       GridView.builder(
  //         shrinkWrap: true,
  //         physics: ScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 3,
  //         ),
  //         itemCount: users.length,
  //         itemBuilder: (gc, index) {
  //           return UserProfile(user: users[index], size: 50, isMute: false);
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget bottom(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            // color: Color(0xffE8FCD9),
            child: Text(
              'Leave room',
              style: TextStyle(
                color: Color(0xffDA6864),
                fontSize: 15,
                fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          Visibility(
            visible: widget.role == ClientRole.Broadcaster,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isMicOn = !isMicOn;
                });
                _engine.muteLocalAudioStream(isMicOn);
              },
              color: Color(0xffE8FCD9),
              icon: Icon(isMicOn ? Icons.mic_off : Icons.mic,
                size: 15, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  initRoom() async {
    // get the details of room
    roomCollection.doc(widget.room.dateTime).snapshots().listen((result) {
      print(result.data()!['speakersCount']);
      setState(() {
        participantsCount = result.data()!['participantsCount'];
        speakersCount = result.data()!['speakersCount'];
      });
    });
  }
}
