import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/Old.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/UserProfile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Cafe extends StatefulWidget {
  final Room room;
  final ClientRole role;
  const Cafe({Key? key, required this.room, required this.role}) : super(key: key);

  @override
  State<Cafe> createState() => _CafeState();
}

class _CafeState extends State<Cafe> with FostrTheme {
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
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Material(
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingH + const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(ICONS + "menu.svg"),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.room.title}",
                            style: h1,
                          ),
                        ),
                      ),
                      Expanded(child: body())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          image: new AssetImage("assets/images/cafe-main.png"),
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
                  .doc(widget.room.title)
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
                      return Container(
                        color: Colors.red,
                        child: UserProfile(
                            user: OldUser.fromJson(map[index]),
                            size: 50,
                            isMute: false,
                            isSpeaker: true),
                      );
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
              backgroundColor: MaterialStateProperty.all(Color(0xffE8FCD9)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
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

}