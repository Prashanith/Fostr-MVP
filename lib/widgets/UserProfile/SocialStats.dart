import 'package:flutter/material.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/screen/FollowFollowing.dart';
import 'package:fostr/utils/theme.dart';
import 'package:sizer/sizer.dart';

class SocialStats extends StatelessWidget with FostrTheme {
  SocialStats({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: h2.copyWith(fontSize: 14.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              FostrRouter.gotoWithArg(
                context,
                FollowFollowing(
                  items: user.followers,
                  title: "Followers",
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  "Followers",
                  style: TextStyle(
                      color: Color(0xffFF613A)
                  ),
                ),
                Text(
                  user.followers?.length.toString() ?? "0",
                ),

              ],
            ),
          ),
          Container(
            height: 40,
            width: 2,
            color: Colors.black.withOpacity(0.2),
          ),
          InkWell(
            onTap: () {
              FostrRouter.gotoWithArg(
                context,
                FollowFollowing(
                  items: user.followings,
                  title: "Following",
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  "Following",
                  style: TextStyle(
                    color: Color(0xffFF613A)
                  ),
                ),
                Text(
                  user.followings?.length.toString() ?? "0",
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
