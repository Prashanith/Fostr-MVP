import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:fostr/utils/widget_constants.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:fostr/widgets/UserProfile/SocialStats.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  TextEditingController controller = TextEditingController();

  bool isClub = false;
  UserService userServices = GetIt.I<UserService>();

  void updateProfile(Map<String, dynamic> data) async {
    await userServices.updateUserField(data);
  }

  Future<void> showPopUp(String field, String uid, Function cb,
      {String? value, int? maxLine}) {
    return displayTextInputDialog(context, field,
        maxLine: maxLine, value: value)
        .then((shouldUpdate) {
      if (shouldUpdate[0]) {
        cb(shouldUpdate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currentUser = auth.user!;
    if (currentUser.followings != null) {
      if (currentUser.followings!.contains(widget.user.id)) {
        isFollowed = true;
      }
    }
    // print(isFollowed);
    // return SafeArea(
    //   child: Scaffold(
    //     body: Container(
    //       height: double.infinity,
    //       decoration: BoxDecoration(gradient: secondaryBackground),
    //       child: SingleChildScrollView(
    //         child: Container(
    //           constraints: BoxConstraints(
    //             minHeight: 100.h,
    //           ),
    //           width: double.infinity,
    //           decoration: BoxDecoration(gradient: secondaryBackground),
    //           child: Stack(
    //             children: [
    //               Positioned(
    //                 top: -350,
    //                 left: -230,
    //                 child: Container(
    //                   height: 600,
    //                   width: 600,
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 20),
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(vertical: 3.h),
    //                       child: Row(
    //                         children: [
    //                           InkWell(
    //                             onTap: () async {
    //                               FostrRouter.pop(context);
    //                             },
    //                             child: Icon(
    //                               Icons.arrow_back,
    //                               size: 20.sp,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 4.w,
    //                           ),
    //                           SizedBox(
    //                             width: 250,
    //                             child: Text(
    //                               widget.user.userName,
    //                               style:
    //                                   h1.copyWith(fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(bottom: 3.h),
    //                       child: Row(
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           RoundedImage(
    //                             width: 100,
    //                             height: 100,
    //                             borderRadius: 35,
    //                             url: widget.user.userProfile?.profileImage,
    //                           ),
    //                           SizedBox(width: 20),
    //                           (widget.user.userProfile != null)
    //                               ? Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.start,
    //                                   children: [
    //                                     (widget.user.userProfile != null &&
    //                                             widget.user.userProfile!
    //                                                     .twitter !=
    //                                                 null &&
    //                                             widget.user.userProfile!
    //                                                 .twitter!.isNotEmpty)
    //                                         ? IconButton(
    //                                             icon: FaIcon(
    //                                                 FontAwesomeIcons.twitter),
    //                                             color: Colors.teal[800],
    //                                             iconSize: 30,
    //                                             onPressed: () {
    //                                               try {
    //                                                 var twitter = widget.user
    //                                                     .userProfile!.twitter!;
    //                                                 if (twitter.isNotEmpty &&
    //                                                     twitter[0] == '@') {
    //                                                   twitter =
    //                                                       twitter.substring(1);
    //                                                 }
    //                                                 url.launch(
    //                                                     "https://twitter.com/$twitter");
    //                                               } catch (e) {}
    //                                             })
    //                                         : SizedBox.shrink(),
    //                                     (widget.user.userProfile != null &&
    //                                             widget.user.userProfile!
    //                                                     .instagram !=
    //                                                 null &&
    //                                             widget.user.userProfile!
    //                                                 .instagram!.isNotEmpty)
    //                                         ? IconButton(
    //                                             icon: FaIcon(
    //                                                 FontAwesomeIcons.instagram),
    //                                             color: Colors.teal[800],
    //                                             iconSize: 30,
    //                                             onPressed: () {
    //                                               try {
    //                                                 var insta = widget
    //                                                     .user
    //                                                     .userProfile!
    //                                                     .instagram!;
    //                                                 print(insta);
    //                                                 if (insta.isNotEmpty &&
    //                                                     insta[0] == '@') {
    //                                                   insta =
    //                                                       insta.substring(1);
    //                                                 }
    //                                                 print(insta);
    //                                                 url.launch(
    //                                                     "http://instagram.com/$insta");
    //                                               } catch (e) {}
    //                                             })
    //                                         : SizedBox.shrink(),
    //                                     (widget.user.userProfile != null &&
    //                                             widget.user.userProfile!
    //                                                     .linkedIn !=
    //                                                 null &&
    //                                             widget.user.userProfile!
    //                                                 .linkedIn!.isNotEmpty)
    //                                         ? IconButton(
    //                                             icon: FaIcon(FontAwesomeIcons
    //                                                 .linkedinIn),
    //                                             color: Colors.teal[800],
    //                                             iconSize: 30,
    //                                             onPressed: () {
    //                                               try {
    //                                                 var linkedIn = widget.user
    //                                                     .userProfile!.linkedIn!;
    //                                                 if (linkedIn.isNotEmpty &&
    //                                                     linkedIn[0] == '@') {
    //                                                   linkedIn =
    //                                                       linkedIn.substring(1);
    //                                                 }
    //                                                 url.launch(
    //                                                     "https://www.linkedin.com/in/$linkedIn");
    //                                               } catch (e) {}
    //                                             })
    //                                         : SizedBox.shrink(),
    //                                   ],
    //                                 )
    //                               : SizedBox.shrink(),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(bottom: 2.h),
    //                       child: Row(
    //                         children: [
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               InkWell(
    //                                 onTap: () async {},
    //                                 child: Text(
    //                                   (widget.user.bookClubName != null &&
    //                                           widget.user.bookClubName!
    //                                               .isNotEmpty)
    //                                       ? widget.user.bookClubName!
    //                                       : (widget.user.name.isEmpty)
    //                                           ? ""
    //                                           : widget.user.name,
    //                                   // overflow: TextOverflow.ellipsis,
    //                                   style: h1.copyWith(
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 22.sp),
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: 5,
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     InkWell(
    //                       onTap: () async {
    //                         if (!isFollowed) {
    //                           var newUser = await userService.followUser(
    //                               auth.user!, widget.user);
    //                           setState(() {
    //                             isFollowed = true;
    //                           });
    //                           auth.refreshUser(newUser);
    //                           Fluttertoast.showToast(
    //                               msg: "Followed Successfully!",
    //                               toastLength: Toast.LENGTH_SHORT,
    //                               gravity: ToastGravity.BOTTOM,
    //                               timeInSecForIosWeb: 1,
    //                               backgroundColor: gradientBottom,
    //                               textColor: Colors.white,
    //                               fontSize: 16.0);
    //                         } else {
    //                           var newUser = await userService.unfollowUser(
    //                               auth.user!, widget.user);
    //                           setState(() {
    //                             isFollowed = false;
    //                           });
    //                           auth.refreshUser(newUser);
    //                           Fluttertoast.showToast(
    //                               msg: "Unfollowed Successfully!",
    //                               toastLength: Toast.LENGTH_SHORT,
    //                               gravity: ToastGravity.BOTTOM,
    //                               timeInSecForIosWeb: 1,
    //                               backgroundColor: gradientBottom,
    //                               textColor: Colors.white,
    //                               fontSize: 16.0);
    //                         }
    //                       },
    //                       child: Container(
    //                         alignment: Alignment.center,
    //                         padding: const EdgeInsets.all(10),
    //                         width: 90.w,
    //                         height: 60,
    //                         decoration: BoxDecoration(
    //                           color: Color(0xffEBFFEE),
    //                           borderRadius: BorderRadius.circular(13),
    //                           boxShadow: boxShadow,
    //                         ),
    //                         child: Text(
    //                           (!isFollowed) ? "Follow" : "Unfollow",
    //                           style: h1.copyWith(
    //                             fontSize: 20.sp,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 2.h,
    //                     ),
    //                     Align(
    //                       alignment: Alignment.centerLeft,
    //                       child: Text(
    //                         'Bio',
    //                         textAlign: TextAlign.start,
    //                         style: TextStyle(
    //                           fontSize: 18.sp,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.teal[900],
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 15,
    //                     ),
    //                     Container(
    //                       padding: EdgeInsets.symmetric(horizontal: 20),
    //                       height: 80,
    //                       decoration: ShapeDecoration(
    //                         gradient: LinearGradient(
    //                           colors: [
    //                             const Color(0xFF80CBC4),
    //                             const Color(0xFFB2DFDB),
    //                           ],
    //                           begin: Alignment.bottomCenter,
    //                           end: Alignment.center,
    //                           stops: [0.0, 0.5],
    //                           tileMode: TileMode.clamp,
    //                         ),
    //                         shadows: [
    //                           BoxShadow(
    //                             offset: Offset(-5, -4),
    //                             blurRadius: 20,
    //                             color: Colors.black.withOpacity(0.25),
    //                           )
    //                         ],
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(15)),
    //                         ),
    //                       ),
    //                       alignment: Alignment.center,
    //                       child: Text(
    //                         widget.user.userProfile?.bio ?? "",
    //                         style: h2.copyWith(
    //                             fontSize: 17, fontWeight: FontWeight.bold),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 15,
    //                     ),
    //                     Column(
    //                       children: [
    //                         Container(
    //                           alignment: Alignment.topLeft,
    //                           child: Row(
    //                             children: [
    //                               Text(
    //                                 'Top Reads:',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 15,
    //                                     color: Colors.teal[900]),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         // Container(
    //                         //   padding: const EdgeInsets.all(15),
    //                         //   alignment: Alignment.center,
    //                         //   decoration: BoxDecoration(
    //                         //     borderRadius:
    //                         //         BorderRadiusDirectional.circular(34),
    //                         //     color: Color(0xFFE6FAED),
    //                         //   ),
    //                         //   width: MediaQuery.of(context).size.width * 0.9,
    //                         //   child: Column(
    //                         //     children: List.generate(
    //                         //       5,
    //                         //       (index) => Padding(
    //                         //         padding: const EdgeInsets.symmetric(
    //                         //             vertical: 10),
    //                         //         child: Align(
    //                         //           alignment: Alignment.centerLeft,
    //                         //           child: Text(
    //                         //             widget.user.userProfile
    //                         //                     ?.favouriteBooks?[index] ??
    //                         //                 "",
    //                         //             style: h2.copyWith(
    //                         //                 fontSize: 16,
    //                         //                 fontWeight: FontWeight.bold),
    //                         //           ),
    //                         //         ),
    //                         //       ),
    //                         //     ),
    //                         //   ),
    //                         // ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Positioned(
    //                   top: 10,
    //                   right: 10,
    //                   child: Tooltip(
    //                     message: "Report User",
    //                     child: IconButton(
    //                         icon: Icon(Icons.report),
    //                         onPressed: () =>
    //                             launch("https://www.fostrreads.com/contact")),
    //                   )),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
                                  Icons.arrow_back_ios,
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
                              RoundedImage(
                                width: 90,
                                height: 90,
                                borderRadius: 35,
                                url: widget.user.userProfile?.profileImage,
                              ),
                              SizedBox(width: 20),
                                                        (widget.user.userProfile != null)
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.start,
                                                                children: [
                                                                  (widget.user.userProfile != null &&
                                                                          widget.user.userProfile!
                                                                                  .twitter !=
                                                                              null &&
                                                                          widget.user.userProfile!
                                                                              .twitter!.isNotEmpty)
                                                                      ? IconButton(
                                                                          icon: SvgPicture.asset("assets/icons/twitter.svg"),
                                                                          color: Colors.teal[800],
                                                                          iconSize: 30,
                                                                          onPressed: () {
                                                                            try {
                                                                              var twitter = widget.user
                                                                                  .userProfile!.twitter!;
                                                                              if (twitter.isNotEmpty &&
                                                                                  twitter[0] == '@') {
                                                                                twitter =
                                                                                    twitter.substring(1);
                                                                              }
                                                                              url.launch(
                                                                                  "https://twitter.com/$twitter");
                                                                            } catch (e) {}
                                                                          })
                                                                      : SizedBox.shrink(),
                                                                  (widget.user.userProfile != null &&
                                                                          widget.user.userProfile!
                                                                                  .instagram !=
                                                                              null &&
                                                                          widget.user.userProfile!
                                                                              .instagram!.isNotEmpty)
                                                                      ? IconButton(
                                                                          icon: SvgPicture.asset("assets/icons/instagram.svg"),
                                                                          color: Colors.teal[800],
                                                                          iconSize: 30,
                                                                          onPressed: () {
                                                                            try {
                                                                              var insta = widget
                                                                                  .user
                                                                                  .userProfile!
                                                                                  .instagram!;
                                                                              print(insta);
                                                                              if (insta.isNotEmpty &&
                                                                                  insta[0] == '@') {
                                                                                insta =
                                                                                    insta.substring(1);
                                                                              }
                                                                              print(insta);
                                                                              url.launch(
                                                                                  "http://instagram.com/$insta");
                                                                            } catch (e) {}
                                                                          })
                                                                      : SizedBox.shrink(),
                                                                  // (widget.user.userProfile != null &&
                                                                  //         widget.user.userProfile!
                                                                  //                 .linkedIn !=
                                                                  //             null &&
                                                                  //         widget.user.userProfile!
                                                                  //             .linkedIn!.isNotEmpty)
                                                                  //     ? IconButton(
                                                                  //         icon: SvgPicture.asset("assets/icons/facebook.svg"),
                                                                  //         color: Colors.teal[800],
                                                                  //         iconSize: 30,
                                                                  //         onPressed: () {
                                                                  //           try {
                                                                  //             var linkedIn = widget.user
                                                                  //                 .userProfile!.facebook!;
                                                                  //             if (linkedIn.isNotEmpty &&
                                                                  //                 linkedIn[0] == '@') {
                                                                  //               linkedIn =
                                                                  //                   linkedIn.substring(1);
                                                                  //             }
                                                                  //             url.launch(
                                                                  //                 "https://www.linkedin.com/in/$facebook");
                                                                  //           } catch (e) {}
                                                                  //         })
                                                                  //     : SizedBox.shrink(),
                                                                ],
                                                              )
                                                            : SizedBox.shrink(),
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
                                  (auth.userType == UserType.CLUBOWNER)
                                      ? Text(
                                    (widget.user.bookClubName != null)
                                        ? (widget.user.bookClubName!.isEmpty)
                                        ? "Enter Book Club name"
                                        : widget.user.bookClubName!
                                        : "Enter Book Club name",
                                    // overflow: TextOverflow.ellipsis,
                                    style: h1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.sp),
                                  )
                                      : Text(
                                    (widget.user.name.isEmpty)
                                        ? "Enter name"
                                        : widget.user.name,
                                    // overflow: TextOverflow.ellipsis,
                                    style: h1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.sp),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      (widget.user.userName.isEmpty)
                                          ? ""
                                          : '@' + widget.user.userName,
                                      style: h1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text('Bio: ',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              // IconButton(
                              //   icon: FaIcon(FontAwesomeIcons.edit),
                              //   color: Colors.black,
                              //   iconSize: 14,
                              //   onPressed: () {
                              //     controller.text = widget.user.userProfile?.bio ?? "";
                              //     showPopUp("Bio", widget.user.id, (e) {
                              //       setState(() {
                              //         if (widget.user.userProfile == null) {
                              //           var userProfile = UserProfile();
                              //           userProfile.bio = e[1];
                              //           widget.user.userProfile = userProfile;
                              //         } else {
                              //           widget.user.userProfile!.bio = e[1];
                              //         }
                              //         updateProfile({
                              //           "userProfile":
                              //           widget.user.userProfile!.toJson(),
                              //           "id": widget.user.id
                              //         });
                              //       });
                              //     },
                              //         maxLine: 5,
                              //         value: widget.user.userProfile?.bio ?? "");
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 80,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            // shadows: [
                            //   BoxShadow(
                            //     offset: Offset(-5, -4),
                            //     blurRadius: 20,
                            //     color: Colors.black.withOpacity(0.25),
                            //   )
                            // ],
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
                        SizedBox(
                          height: 2.h,
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
                          child: SocialStats(user: widget.user),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            if (!isFollowed) {
                              var newUser = await userService.followUser(
                                  auth.user!, widget.user);
                              setState(() {
                                isFollowed = true;
                              });
                              auth.refreshUser(newUser);
                              Fluttertoast.showToast(
                                  msg: "Followed Successfully!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: gradientBottom,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              var newUser = await userService.unfollowUser(
                                  auth.user!, widget.user);
                              setState(() {
                                isFollowed = false;
                              });
                              auth.refreshUser(newUser);
                              Fluttertoast.showToast(
                                  msg: "Unfollowed Successfully!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: gradientBottom,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            width: 90.w,
                            height: 40,
                            decoration: BoxDecoration(
                              color: GlobalColors.signUpSignInButton,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: boxShadow,
                            ),
                            child: Text(
                              (!isFollowed) ? "Follow" : "Unfollow",
                              style: h1.copyWith(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
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
                                    'Top Reads:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.black),
                                  ),
                                  // IconButton(
                                  //   icon: FaIcon(FontAwesomeIcons.edit),
                                  //   color: Colors.black,
                                  //   iconSize: 14,
                                  //   onPressed: () {
                                  //     FostrRouter.goto(context, Routes.searchBooks);
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection("users").doc(widget.user.id).snapshots(),
                                builder: (context,snapshot){
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting: return new Text('Loading...');
                                    default:
                                      var topReadList = snapshot.data?['userProfile']?['topRead'];
                                      return
                                        topReadList != null ?
                                        new GridView(
                                          shrinkWrap: true,
                                          controller: new ScrollController(keepScrollOffset: false),
                                          // crossAxisCount: 2,
                                          // childAspectRatio: (MediaQuery.of(context).size.width) /
                                          //     (MediaQuery.of(context).size.height/1),

                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.65
                                          ),
                                          children: List.generate(snapshot.data!['userProfile']['topRead'].length, (index) {
                                            return Card(

                                                child:ClipRRect(
                                                  clipBehavior: Clip.antiAlias,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Image.network(
                                                    snapshot.data!['userProfile']['topRead'][index]['image_link'],
                                                    height: MediaQuery.of(context).size.height*0.5,
                                                  ),
                                                ));

                                          }),
                                        )
                                            :
                                        Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:15.0),
                                              child: Text(
                                                'User has no Top Reads',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'acumin-pro',
                                                  fontSize: 15,
                                                ),
                                              ),
                                            )
                                        );
                                  }


                                }
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   padding: const EdgeInsets.all(10),
                            //   constraints: BoxConstraints(
                            //     maxWidth: 90.w,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(13),
                            //     boxShadow: boxShadow,
                            //   ),
                            //   alignment: Alignment.center,
                            //   width: MediaQuery.of(context).size.width * 0.9,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: List.generate(
                            //       3,
                            //       (index) {
                            //         return Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 10, horizontal: 10),
                            //           child: Align(
                            //             alignment: Alignment.centerLeft,
                            //             child: GestureDetector(
                            //               onTap: () {
                            //                 if (user.userProfile
                            //                         ?.favouriteBooks ==
                            //                     null) {
                            //                   controller.value =
                            //                       TextEditingValue(text: "");
                            //                 } else {
                            //                   controller.value =
                            //                       TextEditingValue(
                            //                           text: user.userProfile!
                            //                                   .favouriteBooks![
                            //                               index]);
                            //                 }
                            //                 showPopUp(
                            //                   "Favourite Book",
                            //                   user.id,
                            //                   (e) {
                            //                     setState(() {
                            //                       if (user.userProfile ==
                            //                           null) {
                            //                         var userProfile =
                            //                             UserProfile();
                            //
                            //                         userProfile.favouriteBooks?[
                            //                             index] = e[1];
                            //                         user.userProfile =
                            //                             userProfile;
                            //                       } else if (user.userProfile
                            //                               ?.favouriteBooks ==
                            //                           null) {
                            //                         var arr = List.generate(
                            //                             5, (index) => "");
                            //                         arr[index] = e[1];
                            //                         user.userProfile!
                            //                             .favouriteBooks = arr;
                            //                       } else {
                            //                         user.userProfile!
                            //                                 .favouriteBooks![
                            //                             index] = e[1];
                            //                       }
                            //                     });
                            //                     updateProfile({
                            //                       "userProfile": user
                            //                           .userProfile!
                            //                           .toJson(),
                            //                       "id": user.id
                            //                     });
                            //                   },
                            //                 );
                            //               },
                            //               child: Text(
                            //                 (user.userProfile?.favouriteBooks !=
                            //                             null &&
                            //                         user
                            //                             .userProfile!
                            //                             .favouriteBooks![index]
                            //                             .isNotEmpty)
                            //                     ? user.userProfile!
                            //                         .favouriteBooks![index]
                            //                     : "Tap to enter your favourite book",
                            //                 style: h2.copyWith(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     ).toList(),
                            //   ),
                            // ),
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
                    color: Colors.white,
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
