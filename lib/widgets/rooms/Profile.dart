import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/user/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/screen/ExternalUserProfile.dart';
import 'package:provider/provider.dart';

import '../RoundedImage.dart';

class Profile extends StatelessWidget {
  final User user;
  final double size;
  final bool isMute;
  final bool isSpeaker;

  const Profile(
      {Key? key,
      required this.user,
      required this.size,
      this.isMute = true,
      this.isSpeaker = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    if (auth.user!.id == user.id) {
                      return UserProfilePage();
                    } else {
                      return ExternalProfilePage(
                        user: user,
                      );
                    }
                  },
                ),
              ),
              child: RoundedImage(
                url: user.userProfile?.profileImage,
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
            // moderator(isSpeaker),
            SizedBox(
              width: 100,
              child: Text(
                user.userName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
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
