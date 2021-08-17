import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/models/UserModel/UserProfile.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
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
  bool isClub = false;

  UserService userServices = GetIt.I<UserService>();
  User user = User.fromJson({
    "name": "dsd",
    "userName": "ds",
    "id": "dwad",
    "userType": "USER",
    "createdOn": DateTime.now().toString(),
    "lastLogin": DateTime.now().toString(),
    "invites": 10,
    // "bookClubName": ""
  });

  void updateProfile(Map<String, dynamic> data) async {
    await userServices.updateUserField(data);
  }

  Future<void> showPopUp(String field, String uid, Function cb,
      {String? value, int? maxLine}) {
    return displayTextInputDialog(context, field, maxLine: maxLine)
        .then((shouldUpdate) {
      if (shouldUpdate[0]) {
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
    isClub = auth.userType == UserType.CLUBOWNER;
    return Material(
      child: SafeArea(
        child: Container(
          height: 100.h,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              // decoration: BoxDecoration(gradient: secondaryBackground),
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
                                  FostrRouter.goto(context, Routes.settings);
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
                                    if (file['size'] < 400000) {
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
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Image must be less than 400KB",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: gradientBottom,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                    }
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
                                    color: Color(0xB2476747),
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
                                    color: Color(0xB2476747),
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
                                            "userProfile.instagram": e[1],
                                            "id": user.id
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.linkedinIn),
                                    color: Color(0xB2476747),
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
                                      controller.text = user.bookClubName ?? "";
                                      if (isClub) {
                                      } else {
                                        controller.text = user.name;
                                      }
                                      await showPopUp(
                                        (isClub) ? "Book Club Name" : "Name",
                                        user.id,
                                        (e) {
                                          setState(() {
                                            if (!isClub) {
                                              user.name = e[1];
                                              updateProfile({
                                                "name": user.name,
                                                "id": user.id
                                              });
                                            } else {
                                              user.bookClubName = e[1];
                                              updateProfile({
                                                "bookClubName":
                                                    user.bookClubName,
                                                "id": user.id
                                              });
                                            }
                                          });
                                        },
                                      );
                                    },
                                    child: (auth.userType == UserType.CLUBOWNER)
                                        ? Text(
                                            (user.bookClubName != null)
                                                ? (user.bookClubName!.isEmpty)
                                                    ? "Enter Book Club name"
                                                    : user.bookClubName!
                                                : "Enter Book Club name",
                                            // overflow: TextOverflow.ellipsis,
                                            style: h1.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22.sp),
                                          )
                                        : Text(
                                            (user.name.isEmpty)
                                                ? "Enter name"
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
                            color: Colors.white,
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
                                  showPopUp("Bio", user.id, (e) {
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
                            color: Colors.white,
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
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth: 90.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                boxShadow: boxShadow,
                              ),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  5,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (user.userProfile
                                                    ?.favouriteBooks ==
                                                null) {
                                              controller.value =
                                                  TextEditingValue(text: "");
                                            } else {
                                              controller.value =
                                                  TextEditingValue(
                                                      text: user.userProfile!
                                                              .favouriteBooks![
                                                          index]);
                                            }
                                            showPopUp(
                                              "Favourite Book",
                                              user.id,
                                              (e) {
                                                setState(() {
                                                  if (user.userProfile ==
                                                      null) {
                                                    var userProfile =
                                                        UserProfile();

                                                    userProfile.favouriteBooks?[
                                                        index] = e[1];
                                                    user.userProfile =
                                                        userProfile;
                                                  } else if (user.userProfile
                                                          ?.favouriteBooks ==
                                                      null) {
                                                    var arr = List.generate(
                                                        5, (index) => "");
                                                    arr[index] = e[1];
                                                    user.userProfile!
                                                        .favouriteBooks = arr;
                                                  }
                                                });
                                                updateProfile({
                                                  "userProfile": user
                                                      .userProfile!
                                                      .toJson(),
                                                  "id": user.id
                                                });
                                              },
                                            );
                                          },
                                          child: Text(
                                            (user.userProfile?.favouriteBooks !=
                                                        null &&
                                                    user
                                                        .userProfile!
                                                        .favouriteBooks![index]
                                                        .isNotEmpty)
                                                ? user.userProfile!
                                                    .favouriteBooks![index]
                                                : "Tap to enter your favourite book",
                                            style: h2.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
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
                    maxHeight: (maxLine != null && maxLine > 4) ? 380 : 240,
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
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(
                        height: (maxLine != null && maxLine > 4) ? 180 : 60,
                        child: InputField(
                          maxLine: maxLine ?? 1,
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
}
