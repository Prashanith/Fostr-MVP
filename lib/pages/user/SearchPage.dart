import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Layout.dart';
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

  List<Map<String, dynamic>> clubs = [];
  List<Map<String, dynamic>> users = [];

  final UserService userService = GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
  }

  void searchUsers(String id) async {
    var res = await userService.searchUser(query);
    setState(() {
      clubs = res
          .where((element) =>
              element['userType'] == 'CLUBOWNER' && element['id'] != id)
          .toList();
      users = res
          .where(
              (element) => element['userType'] == 'USER' && element['id'] != id)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Layout(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 60.w,
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
                        child: TextField(
                          style: h2.copyWith(fontSize: 14.sp),
                          onEditingComplete: () {
                            searchUsers(auth.user!.id);
                            FocusScope.of(context).unfocus();
                          },
                          onSubmitted: (e) {
                            print(e);
                          },
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2.h),
                            hintText: "Search",
                            hintStyle: h2.copyWith(fontSize: 14.sp),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => searchUsers(auth.user!.id),
                        child: Container(
                          height: 7.h,
                          width: 7.h,
                          decoration: BoxDecoration(
                              color: Color(0xffEBFFEE),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 16,
                                  color: Colors.black.withOpacity(0.25),
                                )
                              ]),
                          child: Icon(
                            Icons.search_rounded,
                            size: 20.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Divider(
                    endIndent: 40,
                    indent: 40,
                    thickness: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Clubs",
                      style: h1.copyWith(fontSize: 16.sp),
                    ),
                    SvgPicture.asset(
                      ICONS + "menu.svg",
                      color: h1.color,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: clubs.length,
                    itemBuilder: (context, idx) {
                      var user = User.fromJson(clubs[idx]);
                      return UserCard(
                        user: user,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Divider(
                    endIndent: 40,
                    indent: 40,
                    thickness: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Users",
                      style: h1.copyWith(fontSize: 16.sp),
                    ),
                    SvgPicture.asset(
                      ICONS + "menu.svg",
                      color: h1.color,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, idx) {
                      var user = User.fromJson(users[idx]);
                      return UserCard(
                        user: user,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
  final snackBar = SnackBar(content: Text('Followed Successfully!'));
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
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 60.w,
      constraints: BoxConstraints(minHeight: 65),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: Color(0xffEBFFEE),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 16,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 9.w,
            width: 9.w,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (widget.user.name.isNotEmpty)
                  ? Text(
                      widget.user.name,
                      style: h1.copyWith(fontSize: 14.sp),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 5,
              ),
              (widget.user.bookClubName != null &&
                      widget.user.bookClubName!.isNotEmpty)
                  ? Text(
                      widget.user.bookClubName!,
                      style: h1.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    )
                  : SizedBox.shrink(),
              Text(
                "@" + widget.user.userName,
                style: h2.copyWith(fontSize: 12.sp),
              )
            ],
          ),
          InkWell(
            onTap: () async {
              print(auth.user!.id);
              try {
                if (!followed) {
                  var user =
                      await userService.followUser(auth.user!, widget.user);
                  auth.refreshUser(user);
                  setState(() {
                    followed = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: h1.color!),
                shape: BoxShape.circle,
              ),
              child: Icon(
                (followed) ? Icons.check : Icons.add,
                color: h1.color,
                size: 28.sp,
                // size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
