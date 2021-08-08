import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/services/FilePicker.dart';
import 'package:fostr/services/StorageService.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/widgets/RoundedImage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

/// Contain information about current user profile

class UserProfile extends StatefulWidget {

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserService userServices = GetIt.I<UserService>();
  User user = User.fromJson({"name": "", "bio": ""});

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        user = auth.userModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.teal.shade900,
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 25, color: Colors.teal[800]),
        ),
        actions: [
          // Button that logout user
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              FostrRouter.replaceGoto(context, Routes.userChoice);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Icons.book_outlined,
                  color: Colors.teal[800],
                ),
                onPressed: () {}),
            //Spacer(),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.teal[800],
                ),
                onPressed: () {}),

            IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.teal[800],
                ),
                onPressed: () {}),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.teal[800],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
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
                                await Storage.saveFile(file, auth.uid);
                            updateProfile(
                                {"profileImage": url, "id": auth.uid});
                            setState(() {
                              user.profileImage = url;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: RoundedImage(
                          width: 100,
                          height: 100,
                          borderRadius: 35,
                          url: user.profileImage,
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
                            user.name,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800]),
                          ),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () async {
                                await showPopUp("Name", auth.uid, (e) {
                                  setState(() {
                                    user.name = e[1];
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Change Profile',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline,
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
                                    showPopUp("Twitter", auth.uid, (e) {
                                      setState(() {
                                        user.twitter = e[1];
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.instagram),
                                  color: Colors.teal[800],
                                  iconSize: 30,
                                  onPressed: () {
                                    showPopUp("Instagram", auth.uid, (e) {
                                      setState(() {
                                        user.instagram = e[1];
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.linkedinIn),
                                  color: Colors.teal[800],
                                  iconSize: 30,
                                  onPressed: () {
                                    showPopUp("linkedIn", auth.uid, (e) {
                                      setState(() {
                                        user.linkedin = e[1];
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
                        showPopUp("Bio", auth.uid, (e) {
                          setState(() {
                            user.bio = e[1];
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
                //margin: EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                //height: double.infinity,
                //width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 80,
                /*decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    /*gradient: LinearGradient(colors: [
                      const Color(0xe9ffee),
                      const Color(0xa3c4bc),
                    ]),*/
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.shade500,
                        offset: const Offset(-4.0, 4.0),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                      ),
                    ],
                  ),*/
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                alignment: Alignment.center,

                child: Text(
                  user.bio ?? "Enter a bio",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              /*Container(
              height: 100,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.teal[50].withOpacity(0.5),
                    width: 5,
                  ),
                ),
                color: Colors.teal.shade50,
                //padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      /*decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal[200],
                            offset: const Offset(
                              -5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.teal.shade100,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),*/
                      child: Text(
                        profileText,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
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
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.pen),
                          color: Colors.teal[800],
                          iconSize: 16,
                          onPressed: () {},
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
                      borderRadius: BorderRadiusDirectional.circular(15),
                      color: Color(0xFF80CBC4),
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
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 20)),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "e-Habits Book Club",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF80CBC4),
                                const Color(0xFFB2DFDB),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 0.3],
                              tileMode: TileMode.clamp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                          //alignment: Alignment.center,
                          height: 100,
                          width: 150,
                          margin: EdgeInsets.all(10.0),
                          /*child: Text(
                                  'Hyperion',
                                  style: TextStyle(),
                                )*/
                          child: IconButton(
                              alignment: Alignment.topRight,
                              icon: Icon(
                                Icons.bookmark,
                                color: Colors.teal[800],
                              ),
                              onPressed: () {}),
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
