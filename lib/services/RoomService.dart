import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';

class RoomService {
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

  Future createRoom(user, eventname, agenda, imageUrl, password, now) async {
    var roomToken = await getToken(eventname);
    // Add new data to Firestore collection
    await roomCollection.doc(user.id).set({'id': user.id});
    var result = await roomCollection
        .doc(user.id)
        .collection("rooms")
        .doc(eventname)
        .set({
      'participantsCount': 0,
      'speakersCount': 0,
      'title': '${eventname}',
      'agenda': '${agenda}',
      'image': imageUrl,
      'password': '${password}',
      'dateTime': '$now',
      // 'dateTime': dateTextEditingController.text + " " + timeTextEditingController.text,
      'roomCreator': (user.bookClubName == "") ? user.name : user.bookClubName,
      'token': roomToken.toString(),
      'id': user.id
      // });
      // await roomCollection
      //   .doc(user.id)
      //   .collection("rooms")
      //   .doc(eventNameTextEditingController.text)
      //   .collection("speakers")
      //   .doc(user.userName)
      //   .set({
      //     'username': user.userName,
      //     'name': user.name,
      //     'profileImage': user.userProfile?.profileImage ?? "image",
    });
    return result;
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
    ClientRole role = ClientRole.Audience;
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

  Future leaveRoom(room, user, role, speakersCount, participantsCount) async {
    if (role == ClientRole.Broadcaster) {
      // update the list of speakers
      await roomCollection
          .doc(room.id)
          .collection("rooms")
          .doc(room.title)
          .update({
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
  }

  void dispose() {
    roomStream?.cancel();
  }
}
