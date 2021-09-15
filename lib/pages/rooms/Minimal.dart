import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/settings.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/screen/ParticipantsList.dart';
import 'package:fostr/services/RatingsService.dart';
import 'package:fostr/services/RoomService.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/rooms/Profile.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class Minimal extends StatefulWidget {
  final Room room;
  final ClientRole role;
  const Minimal({Key? key, required this.room, required this.role})
      : super(key: key);

  @override
  State<Minimal> createState() => _MinimalState();
}

class _MinimalState extends State<Minimal> with FostrTheme {
  int speakersCount = 0, participantsCount = 0;
  String roompass = "";
  bool muted = false, isMicOn = false;
  late RtcEngine _engine;
  final RatingService _ratingService = GetIt.I<RatingService>();
  final RoomService _roomService = GetIt.I<RoomService>();
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    GetIt.I<RoomService>().initRoom(widget.room,
        (participantsC, speakersC, tokenC, channelNameC, roompassC) {
      setState(() {
        participantsCount = participantsC;
        speakersCount = speakersC;
        token = tokenC;
        channelName = channelNameC;
        roompass = roompassC;
      });
    });
    initialize(auth.user!);
  }

  /// Create Agora SDK instance and initialize
  Future<void> initialize(User user) async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers(user);
    print(channelName);
    print(token);
    print(baseUrl);
    print("got: " + widget.room.token.toString());
    await _engine.joinChannel(widget.room.token, channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = RtcEngine.instance ?? await RtcEngine.create(APP_ID);
    await _engine.enableAudio();
    await _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add Agora event handlers

  void _addAgoraEventHandlers(User user) {
    _engine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {},
        joinChannelSuccess: (channel, uid, elapsed) {
          log(uid.toString() + "---" + channel);
          if (widget.role == ClientRole.Broadcaster) {
            roomCollection
                .doc(widget.room.id)
                .collection("rooms")
                .doc(widget.room.title)
                .collection("speakers")
                .doc(user.userName)
                .update({
              "rtcId": uid.toString(),
            });
          } else {
            roomCollection
                .doc(widget.room.id)
                .collection("rooms")
                .doc(widget.room.title)
                .collection("participants")
                .doc(user.userName)
                .update({
              "rtcId": uid.toString(),
            });
          }
        },
        leaveChannel: (stats) {
          log(stats.toJson().toString());
        },
        userJoined: (uid, elapsed) {
          print('userJoined: $uid');
        },
        userOffline: (id, reason) async {
          log(id.toString() + "---" + reason.toString());

          if (reason == UserOfflineReason.Dropped) {
            int particpants = participantsCount;
            int speakers = speakersCount;
            var res = await roomCollection
                .doc(widget.room.id)
                .collection("rooms")
                .doc(widget.room.title)
                .collection("speakers")
                .where("rtcId", isEqualTo: id.toString())
                .limit(1)
                .get();
            res.docs.forEach((doc) {
              doc.reference.delete();

              speakers = speakers - 1;
            });
            log("speakrssss ------- $speakers");
            var pres = await roomCollection
                .doc(widget.room.id)
                .collection("rooms")
                .doc(widget.room.title)
                .collection("participants")
                .where("rtcId", isEqualTo: id.toString())
                .limit(1)
                .get();
            pres.docs.forEach((doc) {
              doc.reference.delete();
              particpants = particpants - 1;
            });
            log("participants ------- $particpants");

            setState(() {
              speakersCount = speakers;
              participantsCount = particpants;
            });
            await roomCollection
                .doc(widget.room.id)
                .collection("rooms")
                .doc(widget.room.title)
                .update(
              {
                'lastTime': DateTime.now().toString(),
                'speakersCount': speakersCount,
                'participantsCount': participantsCount,
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: paddingH + const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.room.title ?? "Hallway",
                    style: h1.apply(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      showBottomSheet(
                          context: context,
                          builder: (context) {
                            return ParticipantsList(
                              title: "Participants",
                              room: widget.room,
                            );
                          });
                    },
                    child: Icon(
                      FontAwesomeIcons.users,
                      color: Colors.white,
                    ),
                  )
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
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage(IMAGES + "minimalist-main.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // list of speakers
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: roomCollection
                                  .doc(widget.room.id)
                                  .collection("rooms")
                                  .doc(widget.room.title)
                                  .collection('speakers')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.docs.length == 0) {
                                  return Align(
                                    child: Text("No speakers yet!"),
                                    alignment: Alignment.topCenter,
                                  );
                                } else if (snapshot.hasData) {
                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>> map =
                                      snapshot.data!.docs;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemCount: map.length,
                                      padding: EdgeInsets.all(2.0),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Profile(
                                          user:
                                              User.fromJson(map[index].data()),
                                          size: 60,
                                          isMute: false,
                                          isSpeaker: false,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                          bottom(context, user, (newUser) {
                            auth.refreshUser(newUser);
                          }),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottom(BuildContext context, User user, Function(User user) cb) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                _ratingService.setCurrentRoom(
                    widget.room.title!, widget.room.id!, user.id);
                await _engine.leaveChannel();
                final newUser = await _roomService.leaveRoom(widget.room, user,
                    widget.role, speakersCount, participantsCount);
                if (widget.room.id == user.id) {
                  cb(newUser);
                }
                Navigator.pop(context);
              },
              color: Color(0xffE8FCD9),
              icon: Image.asset(IMAGES + "close.png"),
              iconSize: 40),
          Spacer(),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
            child: Visibility(
              visible: widget.role == ClientRole.Broadcaster,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isMicOn = !isMicOn;
                    });
                    _engine.muteLocalAudioStream(isMicOn);
                  },
                  color: Color(0xffE8FCD9),
                  icon: !isMicOn
                      ? Image.asset(IMAGES + "mic.png")
                      : Image.asset(IMAGES + "mic_off.png"),
                  iconSize: 50),
            ),
          ),
        ],
      ),
    );
  }
}
