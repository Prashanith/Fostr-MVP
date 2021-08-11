import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FollowFollowing extends StatefulWidget {
  final List<String>? items;
  final String title;
  FollowFollowing({Key? key, this.items, required this.title})
      : super(key: key);

  @override
  State<FollowFollowing> createState() => _FollowFollowingState();
}

class _FollowFollowingState extends State<FollowFollowing> with FostrTheme {
  final userService = GetIt.I<UserService>();
  List<String> users = [];

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);
    userService.getUserById(auth.user!.id).then((user) {
      if (user != null) {
        setState(() {
          auth.refreshUser(user);
          if (widget.title == "Followings") {
            users = user.followings ?? [];
          } else if (widget.title == "Followers") {
            users = user.followers ?? [];
          }
        });
      } else {
        users = widget.items ?? [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                  boxShadow: boxShadow,
                ),
                child: Text(
                  widget.title,
                  style: h1.copyWith(fontSize: 26.sp),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return UserCard(
                      id: users[index],
                      isFollower: widget.title == "Followers",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final String id;
  final bool isFollower;
  const UserCard({Key? key, required this.id, required this.isFollower})
      : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with FostrTheme {
  User user = User.fromJson({
    "name": "dsd",
    "userName": "ds",
    "id": "dwad",
    "userType": "USER",
    "createdOn": DateTime.now().toString(),
    "lastLogin": DateTime.now().toString(),
    "invites": 10,
  });
  bool followed = true;
  final followedSnackBar = SnackBar(content: Text('Followed Successfully!'));
  final unfollowedSnackBar =
      SnackBar(content: Text('Unfollowed Successfully!'));
  final UserService userService = GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
    userService.getUserById(widget.id).then((value) => {
          if (value != null)
            {
              setState(() {
                user = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 65,
      width: 80.w,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (user.userProfile != null)
                      ? (user.userProfile?.profileImage != null)
                          ? Image.network(
                              user.userProfile!.profileImage!,
                              height: 30,
                              width: 25,
                            ).image
                          : Image.asset(IMAGES + "profile.png").image
                      : Image.asset(IMAGES + "profile.png").image),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style:
                    h1.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "@" + user.userName,
                style: h2.copyWith(fontSize: 14),
              )
            ],
          ),
          Spacer(),
          (!widget.isFollower)
            ? InkWell(
              onTap: () async {
                try {
                  if (!widget.isFollower) {
                    if (!followed) {
                      var newUser =
                          await userService.followUser(auth.user!, user);
                      setState(() {
                        followed = true;
                      });
                      auth.refreshUser(newUser);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(followedSnackBar);
                    } else {
                      var newUser =
                          await userService.unfollowUser(auth.user!, user);
                      setState(() {
                        followed = false;
                      });
                      auth.refreshUser(newUser);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(unfollowedSnackBar);
                    }
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: h2.color,
                ),
                child: Text(
                  (widget.isFollower)
                      ? ""
                      : (followed)
                          ? "Unfollow"
                          : "Follow",
                  style: h2.copyWith(color: Colors.white),
                ),
              ),
            )
            : Container()
        ],
      ),
    );
  }
}
