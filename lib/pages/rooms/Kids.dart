import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/RoomUser.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/rooms/DragProfile.dart';
import 'package:fostr/widgets/rooms/Profile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Kids extends StatefulWidget {
  final Room room;
  final ClientRole role;
  const Kids({Key? key, required this.room, required this.role}) : super(key: key);

  @override
  State<Kids> createState() => _KidsState();
}

class _KidsState extends State<Kids> with FostrTheme {
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
    roomCollection
      .doc(widget.room.id)
      .collection('rooms')
      .doc(widget.room.title)
      .snapshots()
      .listen((result) {
        print(result.data()?['speakersCount']);
        setState(() {
          participantsCount = result.data()?['participantsCount'];
          speakersCount = result.data()?['speakersCount'];
        });
      });
  }
  
  removeUser(User user) async {
    if (widget.role == ClientRole.Broadcaster) {
      // update the list of speakers
      await roomCollection
        .doc(widget.room.id)
        .collection("rooms")
        .doc(widget.room.title)
        .update({
          'speakersCount': speakersCount - 1,
        });
      await roomCollection
        .doc(widget.room.id)
        .collection("rooms")
        .doc(widget.room.title)
        .collection("speakers")
        .doc(user.userName)
        .delete();
    } else {
      // update the list of participants
      await roomCollection
        .doc(widget.room.id)
        .collection("rooms")
        .doc(widget.room.title)
        .update({
          'participantsCount': participantsCount - 1,
        });
      await roomCollection
        .doc(widget.room.id)
        .collection("rooms")
        .doc(widget.room.title)
        .collection("participants")
        .doc(user.userName)
        .delete();
    }

    if ((participantsCount == 0 && speakersCount == 1) ||
        (participantsCount == 1 && speakersCount == 0)) {
      await roomCollection.doc(widget.room.title).delete();
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
                child: Text(
                  widget.room.title ?? "Hallway",
                  style: h1.apply(color: Colors.white),
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(IMAGES + "kids-main.png"),
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
                                  .doc(widget.room.id)
                                  .collection("rooms")
                                  .doc(widget.room.title)
                                  .collection('speakers')
                                  .snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<QueryDocumentSnapshot<Map<String, dynamic>>> map = snapshot.data!.docs;
                                    return Stack(
                                      children: [
                                        DragProfile(user: User.fromJson(map[0].data()), 
                                          offset: Offset(MediaQuery.of(context).size.width*0.05, MediaQuery.of(context).size.height*0.32), isSpeaker: true),
                                        map.length >= 2
                                          ? DragProfile(user: User.fromJson(map[0].data()),
                                              offset: Offset(MediaQuery.of(context).size.width*0.4, MediaQuery.of(context).size.height*0.31), isSpeaker: true)
                                          : Container(),
                                        map.length >= 3
                                          ? DragProfile(user: User.fromJson(map[0].data()),
                                              offset: Offset(MediaQuery.of(context).size.width*0.12, MediaQuery.of(context).size.height*0.42), isSpeaker: true)
                                          : Container(),
                                        map.length >= 4
                                          ? DragProfile(user: User.fromJson(map[0].data()),
                                              offset: Offset(MediaQuery.of(context).size.width*0.6, MediaQuery.of(context).size.height*0.45), isSpeaker: true)
                                          : Container(),
                                        map.length >= 5
                                          ? DragProfile(user: User.fromJson(map[0].data()), 
                                              offset: Offset(MediaQuery.of(context).size.width*0.68, MediaQuery.of(context).size.height*0.35), isSpeaker: true)
                                          : Container(),
                                        map.length >= 6
                                          ? DragProfile(user: User.fromJson(map[0].data()),
                                              offset: Offset(MediaQuery.of(context).size.width*0.72, MediaQuery.of(context).size.height*0.43), isSpeaker: true)
                                          : Container(),
                                        map.length >= 7
                                          ? DragProfile(user: User.fromJson(map[0].data()), 
                                              offset: Offset(MediaQuery.of(context).size.width*0.55, MediaQuery.of(context).size.height*0.335), isSpeaker: true)
                                          : Container(),
                                        map.length == 8
                                          ? DragProfile(user: User.fromJson(map[0].data()),
                                            offset: Offset(MediaQuery.of(context).size.width*0.3, MediaQuery.of(context).size.height*0.45), isSpeaker: true)
                                          : Container(),
                                      ],
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }
                              ),
                              bottom(context, user),
                            ],
                          ),
                        )
                      )
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

  Widget bottom(BuildContext context, User user) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
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
              icon: isMicOn ? Image.asset(IMAGES + "mic.png") : Image.asset(IMAGES + "mic_off.png"),
              iconSize: 15
            ),
          ),
          IconButton(
            onPressed: () {
              removeUser(user);
              Navigator.pop(context);
            },
            color: Color(0xffE8FCD9),
            icon: Image.asset(IMAGES + "close.png"),
            iconSize: 15
          ),
        ],
      ),
    );
  }
}
