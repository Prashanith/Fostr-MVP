import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/services/UserService.dart';
import 'package:get_it/get_it.dart';

class RoomService {
  final UserService _userService = GetIt.I<UserService>();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? roomStream;
  initRoom(room, Function details) async {
    // get the details of room
    roomStream = roomCollection
        .doc(room.id)
        .collection("rooms")
        .doc(room.title)
        .snapshots()
        .listen((result) {
      print(result.data()!['speakersCount']);
      var participantsCount = (result.data()!['participantsCount'] < 0
          ? 0
          : result.data()!['participantsCount']);
      var speakersCount = (result.data()!['speakersCount'] < 0
          ? 0
          : result.data()!['speakersCount']);
      var token = result.data()!['token'];
      var channelName = room.title!;
      var roompass = result.data()!['password'];

      details(participantsCount, speakersCount, token, channelName, roompass);
      print("set");
    });
  }

  Future<User> createRoom(
      User user,
      String eventname,
      String agenda,
      DateTime dateTime,
      TimeOfDay timeOfDay,
      String genre,
      String imageUrl,
      String password,
      String now,
      String adTitle,
      String adDescription,
      String redirectLink,
      String imageUrl2,
      ) async {
    var roomToken = await getToken(eventname);

    await upcomingRoomsCollection.doc(user.id).set({'id': user.id});
    var result = await upcomingRoomsCollection
        .doc(user.id)
        .collection("rooms")
        .doc(eventname)
        .set({
      'participantsCount': 0,
      'speakersCount': 0,
      'title': '$eventname',
      'agenda': '$agenda',
      'image': imageUrl,
      'password': '$password',
      'dateTime': '$dateTime',
      'time': '$timeOfDay',
      'genre': genre,
      'lastTime': '$now',
      'roomCreator': (user.bookClubName == "") ? user.name : user.bookClubName,
      'token': roomToken.toString(),
      'id': user.id,
      'adTitle':adTitle,
      'adDescription':adDescription,
      'redirectLink':redirectLink,
      'imageUrl2':imageUrl2
    });

    // Add new data to Firestore collection

    user.totalRooms = user.totalRooms ?? 0;
    user.totalRooms = user.totalRooms! + 1;
    _userService.updateUserField(user.toJson());
    return user;
  }

  Future<User> createRoomNow(User user, String eventname, String agenda,
      String genre, String imageUrl, String password, String now,
      String adTitle,
      String adDescription,
      String redirectLink,
      String imageUrl2,
      ) async {
    var roomToken = await getToken(eventname);


    await roomCollection.doc(user.id).set({'id': user.id});
    var result = await roomCollection
        .doc(user.id)
        .collection("rooms")
        .doc(eventname)
        .set({
      'participantsCount': 0,
      'speakersCount': 0,
      'title': '$eventname',
      'agenda': '$agenda',
      'image': imageUrl,
      'password': '$password',
      'dateTime': '${DateTime.now()}',
      'genre': genre,
      'lastTime': '$now',
      'roomCreator': (user.bookClubName == "") ? user.name : user.bookClubName,
      'token': roomToken.toString(),
      'id': user.id,
      'adTitle':adTitle,
      'adDescription':adDescription,
      'redirectLink':redirectLink,
      'imageUrl2':imageUrl2
    });

    // Add new data to Firestore collection

    user.totalRooms = user.totalRooms ?? 0;
    user.totalRooms = user.totalRooms! + 1;
    _userService.updateUserField(user.toJson());
    return user;
  }

  getRooms(id) async {
    roomCollection.doc(id).collection("rooms").snapshots();
  }

  Future joinRoomAsSpeaker(
      room, user, enteredpass, roompass, speakersCount) async {
    if (enteredpass != roompass) return null;

    var rawSpeakers = await roomCollection
        .doc(room.id)
        .collection("rooms")
        .doc(room.title)
        .collection("speakers")
        .get();
    var speakers = rawSpeakers.docs.map((e) => e.data()).toList();

    await roomCollection
        .doc(room.id)
        .collection("rooms")
        .doc(room.title)
        .collection("speakers")
        .doc(user.userName)
        .set(user.toJson());
    bool isThere = false;
    speakers.forEach((element) {
      if (element['id'] == user.id && !isThere) {
        isThere = true;
      }
    });

    if (!isThere) {
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .update({
        'speakersCount': speakersCount + 1,
      });

      speakersCount = speakers.length + 1;
    }
    return speakersCount;
  }

  Future joinRoomAsParticipant(room, user, participantsCount) async {
    // update the list of participants
    var rawParticipants = await roomCollection
        .doc(room.id)
        .collection("rooms")
        .doc(room.title)
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
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .update({
        'participantsCount': participantsCount + 1,
      });
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .collection("participants")
          .doc(user.userName)
          .set({
        'username': user.userName,
        'name': user.name,
        'profileImage': user.userProfile?.profileImage ?? "image",
      });

      participantsCount = participants.length + 1;
    }
    return participantsCount;
  }

  Future leaveRoom(Room room, User user, ClientRole role, int speakersCount,
      int participantsCount) async {
    double hours = 0;
    String now = DateTime.now().toString();

    if (speakersCount == 1) {
      DateTime? lastDate = DateTime.tryParse(now);
      DateTime? startDate = DateTime.tryParse(room.dateTime!);

      final diff = lastDate!.difference(startDate!);
      hours =
          double.parse((diff.inSeconds.toDouble() / 3600).toStringAsFixed(2));
      final roomOwner = await _userService.getUserById(room.id!);
      if (roomOwner != null) {
        double totalHours = roomOwner.totlaHours ?? 0;
        totalHours += hours;
        roomOwner.totlaHours = totalHours;
        user = roomOwner;
        _userService.updateUser(roomOwner);
      }
    }
    if (role == ClientRole.Broadcaster) {
      // update the list of speakers
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .update({
        'lastTime': now,
        'speakersCount': speakersCount - 1,
      });
      await roomCollection
          .doc(room.id)
          .collection('rooms')
          .doc(room.title)
          .collection("speakers")
          .doc(user.userName)
          .delete();
    } else {
      // update the list of participants
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .update({
        'participantsCount': participantsCount - 1,
      });
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .collection("participants")
          .doc(user.userName)
          .delete();
    }
    return user;
    // if (participantsCount == 0 && speakersCount == 1) {
    //   deletRoom(room.id!, room.title!);
    // }
  }

  void deletRoom(String roomCreator, String roomTitle) {
    roomCollection.doc(roomCreator).collection('rooms').doc(roomTitle).delete();
  }

  Future<void> dispose() async {
    await roomStream?.cancel();
  }
}