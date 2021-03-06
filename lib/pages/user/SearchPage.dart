import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/screen/ExternalUserProfile.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with FostrTheme {
  String query = "";
  bool searched = false;

  List<Map<String, dynamic>> users = [];
  List<String> containedUsers = [];

  final UserService userService = GetIt.I<UserService>();
  final searchForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void searchUsers(String id) async {
    var res = await userService.searchUser(query);
    setState(() {
      searched = true;
      users = res.where((element) => element['id'] != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(229, 229, 229, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: 90.w,
                          decoration: BoxDecoration(
                              color: Color(0XFFEBFFEE),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 16,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ]),
                          child: Form(
                            key: searchForm,
                            child: TextFormField(
                              validator: (va) {
                                if (va!.isEmpty) {
                                  return "Search can't be empty";
                                }
                              },
                              style: h2.copyWith(fontSize: 14.sp),
                              onEditingComplete: () {
                                searchUsers(auth.user!.id);
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                                if (value.isNotEmpty && value.length >= 3) {
                                  searchUsers(auth.user!.id);
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                hintText: "Search readers here",
                                hintStyle: h2.copyWith(fontSize: 14.sp),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset(IMAGES + "background.png").image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(32),
                      topEnd: Radius.circular(32),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "",
                              style: h1.copyWith(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      // Divider(
                      //   endIndent: 40,
                      //   indent: 40,
                      //   thickness: 2,
                      // ),
                      Expanded(
                        child: (users.length > 0)
                            ? ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, idx) {
                                  var user = User.fromJson(users[idx]);
                                  containedUsers.add(user.id);
                                  return UserCard(
                                    user: user,
                                  );
                                },
                              )
                            : (searched)
                                ? Center(
                                    child: Text(
                                      "No Users or Book Clubs found",
                                      style: h2,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "You can follow some readers here",
                                      style: h2,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class UserCard extends StatefulWidget {
  final User user;
  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with FostrTheme {
  bool followed = false;
  final UserService userService = GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.user!.followings!.contains(widget.user.id)) {
        setState(() {
          followed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return ExternalProfilePage(
                user: widget.user,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: 60.w,
        constraints: BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 16,
              color: Colors.black.withOpacity(0.25),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.user.name.isNotEmpty)
                    ? SizedBox(
                        width: 200,
                        child: Text(
                          widget.user.name,
                          style: h1.copyWith(fontSize: 14.sp),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 5,
                ),
                (widget.user.bookClubName != null &&
                        widget.user.bookClubName!.isNotEmpty)
                    ? SizedBox(
                        width: 200,
                        child: Text(
                          widget.user.bookClubName!,
                          overflow: TextOverflow.ellipsis,
                          style: h1.copyWith(fontSize: 14.sp),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "@" + widget.user.userName,
                  style: h2.copyWith(fontSize: 12.sp),
                )
              ],
            ),
            Container(
              height: 15.w,
              width: 15.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: (widget.user.userProfile != null)
                        ? (widget.user.userProfile?.profileImage != null)
                            ? Image.network(
                                widget.user.userProfile!.profileImage!,
                                height: 30,
                                width: 25,
                              ).image
                            : Image.asset(IMAGES + "profile.png").image
                        : Image.asset(IMAGES + "profile.png").image),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// InkWell(
//             onTap: () async {
//               try {
//                 if (!followed) {
//                   var user =
//                       await userService.followUser(auth.user!, widget.user);
//                   auth.refreshUser(user);
//                   setState(() {
//                     followed = true;
//                   });
//                   Fluttertoast.showToast(
//                       msg: "Followed Successfully!",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: gradientBottom,
//                       textColor: Colors.white,
//                       fontSize: 16.0);
//                 }
//               } catch (e) {
//                 print(e);
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 2, color: h1.color!),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 (followed) ? Icons.check : Icons.add,
//                 color: h1.color,
//                 size: 28.sp,
//                 // size: 30,
//               ),
//             ),
//           )