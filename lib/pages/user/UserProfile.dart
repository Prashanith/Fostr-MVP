import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/models/UserModel/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/screen/FollowFollowing.dart';
import 'package:fostr/services/FilePicker.dart';
import 'package:fostr/services/StorageService.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:fostr/widgets/UserProfile/SocialStats.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with FostrTheme {
  TextEditingController controller = TextEditingController();

  UserService userServices = GetIt.I<UserService>();
  User user = User.fromJson({
    "name": "dsd",
    "userName": "ds",
    "id": "dwad",
    "userType": "USER",
    "createdOn": DateTime.now().toString(),
    "lastLogin": DateTime.now().toString(),
    "invites": 10,
  });

  void updateProfile(Map<String, dynamic> data) async {
    await userServices.updateUserField(data);
  }

  Future<void> showPopUp(String field, String uid, Function cb,
      {String? value, int? maxLine}) {
    return displayTextInputDialog(context, field, maxLine: maxLine)
        .then((shouldUpdate) {
      if (shouldUpdate[0]) {
        final json = {
          "id": uid,
          field.toLowerCase(): shouldUpdate[1],
        };
        updateProfile(json);
        cb(shouldUpdate);
      }
    });
  }

  Future<void> showTextArea(String field, String uid, Function cb,
      {String? value, int? maxLine}) {
    return displayTextAreaDialog(
      context,
      field,
    ).then((shouldUpdate) {
      if (shouldUpdate[0]) {
        final json = {
          "id": uid,
          field.toLowerCase(): shouldUpdate[1],
        };
        updateProfile(json);
        cb(shouldUpdate);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        user = auth.user!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.user != null) {
      user = auth.user!;
    }
    return Material(
      child: SafeArea(
        child: Container(
          height: 100.h,
          child: SingleChildScrollView(
            child: Container(
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
                              Text(
                                "Profile",
                                style: h1.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  FostrRouter.goto(
                                    context,
                                    Routes.settings
                                  );
                                },
                                child: Icon(
                                  Icons.settings_outlined,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  try {
                                    final file = await Files.getFile();
                                    final url =
                                        await Storage.saveFile(file, user.id);
                                    setState(() {
                                      if (user.userProfile == null) {
                                        var userProfile = UserProfile();
                                        userProfile.profileImage = url;
                                        user.userProfile = userProfile;
                                      } else {
                                        user.userProfile!.profileImage = url;
                                      }
                                      updateProfile({
                                        "userProfile":
                                            user.userProfile!.toJson(),
                                        "id": user.id
                                      });
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: RoundedImage(
                                  width: 100,
                                  height: 100,
                                  borderRadius: 35,
                                  url: user.userProfile?.profileImage,
                                ),
                              ),
                              SizedBox(width: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.twitter),
                                    color: Colors.teal[800],
                                    iconSize: 30,
                                    onPressed: () async {
                                      controller.text =
                                          user.userProfile?.twitter ?? "";
                                      await showPopUp("Twitter", user.id, (e) {
                                        setState(() {
                                          if (user.userProfile == null) {
                                            var userProfile = UserProfile();
                                            userProfile.twitter = e[1];
                                            user.userProfile = userProfile;
                                          } else {
                                            user.userProfile!.twitter = e[1];
                                          }
                                          updateProfile({
                                            "userProfile":
                                                user.userProfile!.toJson(),
                                            "id": user.id
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.instagram),
                                    color: Colors.teal[800],
                                    iconSize: 30,
                                    onPressed: () {
                                      controller.text =
                                          user.userProfile?.instagram ?? "";
                                      showPopUp("Instagram", user.id, (e) {
                                        setState(() {
                                          if (user.userProfile == null) {
                                            var userProfile = UserProfile();
                                            userProfile.instagram = e[1];
                                            user.userProfile = userProfile;
                                          } else {
                                            user.userProfile!.instagram = e[1];
                                          }
                                          updateProfile({
                                            "userProfile":
                                                user.userProfile!.toJson(),
                                            "id": user.id
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.linkedinIn),
                                    color: Colors.teal[800],
                                    iconSize: 30,
                                    onPressed: () {
                                      controller.text =
                                          user.userProfile?.linkedIn ?? "";
                                      showPopUp("linkedIn", user.id, (e) {
                                        setState(() {
                                          if (user.userProfile == null) {
                                            var userProfile = UserProfile();
                                            userProfile.linkedIn = e[1];
                                            user.userProfile = userProfile;
                                          } else {
                                            user.userProfile!.linkedIn = e[1];
                                          }
                                          updateProfile({
                                            "userProfile":
                                                user.userProfile!.toJson(),
                                            "id": user.id
                                          });
                                        });
                                      });
                                    },
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
                                    onTap: () async {
                                      controller.text = user.name;
                                      await showPopUp(
                                        "Name",
                                        user.id,
                                        (e) {
                                          setState(() {
                                            user.name = e[1];
                                            updateProfile({
                                              "name": user.name,
                                              "id": user.id
                                            });
                                          });
                                        },
                                      );
                                    },
                                    child: Text(
                                      (user.name.isEmpty)
                                          ? "Enter your name"
                                          : user.name,
                                      // overflow: TextOverflow.ellipsis,
                                      style: h1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (user.userName.isEmpty)
                                        ? ""
                                        : '@' + user.userName,
                                    style: h1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: 90.w,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffEBFFEE),
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: boxShadow,
                          ),
                          child: SocialStats(user: user),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text('A quote that describe me is:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal[900])),
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.pen),
                                color: Colors.teal[800],
                                iconSize: 16,
                                onPressed: () {
                                  controller.text = user.userProfile?.bio ?? "";
                                  showTextArea("Bio", user.id, (e) {
                                    setState(() {
                                      if (user.userProfile == null) {
                                        var userProfile = UserProfile();
                                        userProfile.bio = e[1];
                                        user.userProfile = userProfile;
                                      } else {
                                        user.userProfile!.bio = e[1];
                                      }
                                      updateProfile({
                                        "userProfile":
                                            user.userProfile!.toJson(),
                                        "id": user.id
                                      });
                                    });
                                  }, maxLine: 5);
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 80,
                          decoration: ShapeDecoration(
                            // gradient: LinearGradient(
                            //   colors: [
                            //     const Color(0xFF80CBC4),
                            //     const Color(0xFFB2DFDB),
                            //   ],
                            //   begin: Alignment.bottomCenter,
                            //   end: Alignment.center,
                            //   stops: [0.0, 0.5],
                            //   tileMode: TileMode.clamp,
                            // ),
                            color: Color(0xFFE6FAED),
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
                            user.userProfile?.bio ?? "Enter a bio",
                            style: h2.copyWith(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Favourite Books:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.teal[900]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(34),
                                color: Color(0xFFE6FAED),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "e-Habits Book Club",
                                        style: h2.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
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

  Future displayTextInputDialog(BuildContext context, String field,
      {String? value, int? maxLine}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height,
          width: size.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Align(
              alignment: Alignment(0, -0.5),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: size.width * 0.9,
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffB2D6C3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your $field',
                        style: h2.copyWith(
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: InputField(
                          maxLine: maxLine,
                          controller: controller,
                          hintText: value,
                          onChange: (v) {
                            value = v;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([false]);
                            },
                            child: Text(
                              "CANCEL",
                              style: h2.copyWith(
                                fontSize: 17.sp,
                                // color: Colors.redAccent,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([true, value]);
                            },
                            child: Text(
                              "UPDATE",
                              style: h2.copyWith(
                                fontSize: 17.sp,
                                // color: Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future displayTextAreaDialog(BuildContext context, String field,
      {String? value}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return Container(
          height: size.height,
          width: size.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Align(
              alignment: Alignment(0, -0.5),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: size.width * 0.9,
                  constraints: BoxConstraints(
                    maxHeight: 380,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffB2D6C3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your $field',
                        style: h2.copyWith(
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: InputField(
                          maxLine: 10,
                          controller: controller,
                          hintText: value,
                          onChange: (v) {
                            value = v;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([false]);
                            },
                            child: Text(
                              "CANCEL",
                              style: h2.copyWith(
                                fontSize: 16.sp,
                                // color: Colors.redAccent,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([true, value]);
                            },
                            child: Text(
                              "UPDATE",
                              style: h2.copyWith(
                                fontSize: 16.sp,
                                // color: Colors.green,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
