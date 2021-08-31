import 'package:flutter/services.dart';

class AgoraChannel {
  final platform = MethodChannel("com.clubfostr.fostr");

  Future<void> setAgoraUserId(
      String creatorId, String roomId, String userId, String role) async {
    final id = [creatorId, roomId, userId, role];

    try {
      final int result = await platform.invokeMethod("setID");
    } catch (e) {}
  }
}
