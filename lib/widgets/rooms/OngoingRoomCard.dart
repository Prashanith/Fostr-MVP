import 'dart:ui';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OngoingRoomCard extends StatelessWidget with FostrTheme {
  final Room room;

  OngoingRoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: double.infinity,
            // height: MediaQuery.of(context).size.height * 0.25,
            constraints: BoxConstraints(maxHeight: 150, maxWidth: 370),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffAAC8B1),
                  Color(0xffA5C5BD),
                ],
              ),
              // image: DecorationImage(
              // image: (room.imageUrl != null && room.imageUrl!.isNotEmpty)
              //     ? NetworkImage(room.imageUrl!)
              //     : Image.asset(IMAGES + "logo_white.png").image,
              //   fit: BoxFit.cover,
              // ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.25),
                )
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: (room.imageUrl != null &&
                                    room.imageUrl!.isNotEmpty)
                                ? Image.network(room.imageUrl!).image
                                : Image.asset(IMAGES + "logo_white.png").image),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            ICONS + "people.svg",
                            height: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            (room.participantsCount! < 0
                                ? "0"
                                : room.participantsCount.toString()),
                            style: h2.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          SvgPicture.asset(
                            ICONS + "mic.svg",
                            height: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            (room.speakersCount! < 0
                                ? "0"
                                : room.speakersCount.toString()),
                            style: h2.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "by " + room.roomCreator.toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          fontFamily: "Lato",
                        ),
                      ),
                      Spacer(),
                      Text(
                        room.title.toString(),
                        style: h2.copyWith(
                            color: Colors.black87, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        room.agenda.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontFamily: "Lato",
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat('dd-MMM-yy (KK:mm) aa')
                            .format(DateTime.parse(room.dateTime.toString())),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: "Lato",
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        room.roomCreator ==
                ((user.bookClubName == "") ? user.name : user.bookClubName)
            ? Positioned(
                right: 5,
                bottom: 5,
                child: IconButton(
                    icon: Icon(Icons.delete_outline_rounded),
                    onPressed: () async {
                      if (await confirm(
                        context,
                        title: Text('Confirm'),
                        content:
                            Text('Are you sure you want to delete this room?'),
                        textOK: Text('Yes'),
                        textCancel: Text('No'),
                      )) {
                        roomCollection
                            .doc(user.id)
                            .collection('rooms')
                            .doc(room.title)
                            .delete();
                      }
                      return;
                    }),
              )
            : Container(),
        // Positioned(
        //   right: 8,
        //   top: 20,
        //   child: BookmarkContainer(imgURL: room.imageUrl),
        // ),
      ],
    );
  }
}
