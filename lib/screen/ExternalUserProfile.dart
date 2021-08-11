import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class ExternalProfilePage extends StatefulWidget {
  final User user;
  ExternalProfilePage({Key? key, required this.user}) : super(key: key);
  @override
  State<ExternalProfilePage> createState() => _ExternalProfilePageState();
}

class _ExternalProfilePageState extends State<ExternalProfilePage>
    with FostrTheme {
  final UserService userService = GetIt.I<UserService>();

  bool isFollowed = false;

  final followedSnackBar = SnackBar(content: Text('Followed Successfully!'));
  final unfollowedSnackBar =
      SnackBar(content: Text('Unfollowed Successfully!'));

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currentUser = auth.user!;
    if (currentUser.followers != null) {
      if (currentUser.followers!.contains(widget.user.id)) {
        isFollowed = true;
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 100.h,
          child: SingleChildScrollView(
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(gradient: secondaryBackground),
              child: Stack(
                children: [
                  Positioned(
                    top: -350,
                    left: -230,
                    child: Container(
                      height: 600,
                      width: 600,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  FostrRouter.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                widget.user.userName,
                                style: h1.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RoundedImage(
                                width: 100,
                                height: 100,
                                borderRadius: 35,
                                url: widget.user.userProfile?.profileImage,
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.twitter),
                                      color: Colors.teal[800],
                                      iconSize: 30,
                                      onPressed: () async {}),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.instagram),
                                    color: Colors.teal[800],
                                    iconSize: 30,
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.linkedinIn),
                                    color: Colors.teal[800],
                                    iconSize: 30,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () async {},
                                    child: Text(
                                      (widget.user.name.isEmpty)
                                          ? ""
                                          : widget.user.name,
                                      // overflow: TextOverflow.ellipsis,
                                      style: h1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          width: 90.w,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffEBFFEE),
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: boxShadow,
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (!isFollowed) {
                                var newUser = await userService.followUser(
                                    auth.user!, widget.user);
                                setState(() {
                                  isFollowed = true;
                                });
                                auth.refreshUser(newUser);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(followedSnackBar);
                              } else {
                                var newUser = await userService.unfollowUser(
                                    auth.user!, widget.user);
                                setState(() {
                                  isFollowed = false;
                                });
                                auth.refreshUser(newUser);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(unfollowedSnackBar);
                              }
                            },
                            child: Text(
                              (!isFollowed) ? "Follow" : "Unfollow",
                              style: h1.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Bio',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal[900],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 80,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF80CBC4),
                                const Color(0xFFB2DFDB),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              stops: [0.0, 0.5],
                              tileMode: TileMode.clamp,
                            ),
                            shadows: [
                              BoxShadow(
                                offset: Offset(-5, -4),
                                blurRadius: 20,
                                color: Colors.black.withOpacity(0.25),
                              )
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.user.userProfile?.bio ?? "",
                            style: h2.copyWith(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}