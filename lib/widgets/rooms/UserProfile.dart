import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';

import '../RoundedImage.dart';

class UserProfile extends StatelessWidget {
  final User user;
  final double size;
  final bool isMute;
  final bool isSpeaker;

  const UserProfile(
      {Key? key,
      required this.user,
      required this.size,
      this.isMute = true,
      this.isSpeaker = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/profile',
                arguments: user,
              ),
              child: RoundedImage(
                path: IMAGES + "profile.png",
                width: size,
                height: size,
              ),
            ),
            mute(isMute),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            moderator(isSpeaker),
            Text(
              user.name.split(' ')[0],
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Return if user is moderator
  Widget moderator(bool isSpeaker) {
    return isSpeaker
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.star, color: Colors.white, size: 12),
          )
        : Container();
  }

  ///Return if user is mute
  Widget mute(bool isMute) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: isMute
          ? Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Icon(Icons.mic_off),
            )
          : Container(),
    );
  }
}
