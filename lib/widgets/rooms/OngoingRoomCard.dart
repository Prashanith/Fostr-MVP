import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/utils/theme.dart';
import 'package:intl/intl.dart';

import 'BookmarkContainer.dart';
class OngoingRoomCard extends StatelessWidget with FostrTheme {
  final Room room;

  OngoingRoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            // height: MediaQuery.of(context).size.height * 0.25,
            constraints: BoxConstraints(
              maxHeight: 150,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff9BC8B1),
                  Color(0xffA5C5BD),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.25),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      ICONS + "people.svg",
                      height: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      (room.participantsCount! < 0 ? "0" : room.participantsCount.toString()),
                      style: h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SvgPicture.asset(
                      ICONS + "mic.svg",
                      height: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      (room.speakersCount! < 0 ? "0" : room.speakersCount.toString()),
                      style: h2.copyWith(
                        color: Colors.white,
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
                    color: Color(0xffffffff),
                    fontSize: 11,
                    fontFamily: "Lato",
                  ),
                ),
                Spacer(),
                Text(
                  room.title.toString(),
                  style: h2.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  room.agenda.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('dd-MMM-yy (KK:mm) aa').format(DateTime.parse(room.dateTime.toString())),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: BookmarkContainer(imgURL: room.imageUrl),
        ),
      ],
    );
  }
}
