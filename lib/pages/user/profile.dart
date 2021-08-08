import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// /// Contain information about current user profile

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with FostrTheme {
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

  Future<void> showPopUp(String field, String uid, Function cb) {
    return displayTextInputDialog(context, field).then((shouldUpdate) {
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
    return Material(
      color: Color(0xffD7E9DE),
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xffD8F7E2),
                    Color(0xff8CB7AB),
                  ])),
            ),
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
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ICONS + "menu.svg",
                            color: Color(0xffA2ABB9),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Profile",
                            style: h1.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              await auth.signOut();
                              FostrRouter.removeUntillAndGoto(
                                context,
                                Routes.userChoice,
                                (route) => false,
                              );
                            },
                            child: Icon(
                              Icons.logout_outlined,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            //profileBody(),
                            /*Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),*/
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
                                      "userProfile": user.userProfile!.toJson(),
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
                            SizedBox(height: 20),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  (user.name.isEmpty)
                                      ? "Enter your name"
                                      : user.name,
                                  style:
                                      h1.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await showPopUp("Name", user.id, (e) {
                                        setState(() {
                                          user.name = e[1];
                                          updateProfile({
                                            "name": user.name,
                                            "id": user.id
                                          });
                                        });
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Change Profile',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        IconButton(
                                          icon: FaIcon(FontAwesomeIcons.pen),
                                          color: Colors.teal[800],
                                          iconSize: 16,
                                          onPressed: () => null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /*Text(
                                profile.username,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),*/
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.twitter),
                                        color: Colors.teal[800],
                                        iconSize: 30,
                                        onPressed: () {
                                          showPopUp("Twitter", user.id, (e) {
                                            setState(() {
                                              if (user.userProfile == null) {
                                                var userProfile = UserProfile();
                                                userProfile.twitter = e[1];
                                                user.userProfile = userProfile;
                                              } else {
                                                user.userProfile!.twitter =
                                                    e[1];
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
                                        icon:
                                            FaIcon(FontAwesomeIcons.instagram),
                                        color: Colors.teal[800],
                                        iconSize: 30,
                                        onPressed: () {
                                          showPopUp("Instagram", user.id, (e) {
                                            setState(() {
                                              if (user.userProfile == null) {
                                                var userProfile = UserProfile();
                                                userProfile.instagram = e[1];
                                                user.userProfile = userProfile;
                                              } else {
                                                user.userProfile!.instagram =
                                                    e[1];
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
                                        icon:
                                            FaIcon(FontAwesomeIcons.linkedinIn),
                                        color: Colors.teal[800],
                                        iconSize: 30,
                                        onPressed: () {
                                          showPopUp("linkedIn", user.id, (e) {
                                            setState(() {
                                              if (user.userProfile == null) {
                                                var userProfile = UserProfile();
                                                userProfile.linkedIn = e[1];
                                                user.userProfile = userProfile;
                                              } else {
                                                user.userProfile!.linkedIn =
                                                    e[1];
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
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /*Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Change Profile',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),*/
                    SizedBox(
                      height: 20,
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
                                    "userProfile": user.userProfile!.toJson(),
                                    "id": user.id
                                  });
                                });
                              });
                            },
                          ),
                        ],
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                'Up Next:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.teal[900]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(34),
                            color: Color(0xFFE6FAED),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                              children: List.generate(
                            3,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text("17:30",
                                      style: h2.copyWith(
                                        color: Color(0xff6E664E),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "e-Habits Book Club",
                                    style: h2.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Top Rooms:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal[900]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 370,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 0),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffE5EEEE),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                //alignment: Alignment.center,
                                height: 128,
                                width: 153,
                                margin: EdgeInsets.all(10.0),
                                /*child: Text(
                                        'Hyperion',
                                        style: TextStyle(),
                                      )*/
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment(1, -1.05),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.bookmark,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future displayTextInputDialog(BuildContext context, String field) async {
    String value = "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter your $field'),
            content: TextField(
              onChanged: (v) {
                value = v;
              },
              decoration: InputDecoration(hintText: " "),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop([false]);
                },
              ),
              TextButton(
                child: Text('UPDATE'),
                onPressed: () {
                  Navigator.of(context).pop([true, value]);
                  // setState(() {
                  //   codeDialog = enteredChannelName;
                  //   Navigator.pop(context);
                  // });
                },
              ),
            ],
          );
        });
  }
}
