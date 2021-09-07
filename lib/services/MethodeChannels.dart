import 'dart:developer';

import 'package:flutter/services.dart';

class AgoraChannel {
  final _platform = MethodChannel("com.clubfostr.fostr");

  Future<void> setAgoraUserId(
      String creatorId, String roomId, String userId, String role) async {
    try {
      final int result = await _platform.invokeMethod("setID", {
        "creatorId": creatorId,
        "roomId": roomId,
        "userId":userId,
        "role": role,
      });
      log(result.toString());
    } catch (e) {
      print(e);
    }
  }
}
