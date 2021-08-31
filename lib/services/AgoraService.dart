import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fostr/core/constants.dart';

class AgoraService {
  RtcEngine? get engine => RtcEngine.instance;

  AgoraService.init() {
    initEngine();
  }

  Future<RtcEngine?> initEngine() async {
    try {
      await RtcEngine.create(AGORA_APP_ID);
      _addAgoraEventHandlers();
    } catch (e) {}
  }

  Future<void> destroyEngine() async {
    try {
      log("destroying Engine");
      await engine?.leaveChannel();
      await engine?.destroy();
    } catch (e) {}
  }

  void _addAgoraEventHandlers() {
    engine!.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {},
        joinChannelSuccess: (channel, uid, elapsed) {
          log(uid.toString() + "---" + channel);
        },
        leaveChannel: (stats) {
          log(stats.toJson().toString());
        },
        userJoined: (uid, elapsed) {
          print('userJoined: $uid');
        },
        userOffline: (id, reason) {
          log(id.toString() + "---" + reason.toString());
        },
      ),
    );
  }
}
