import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/clubOwner/dashboard.dart';
import 'package:fostr/router/router.dart';
import 'package:fostr/router/routes.dart';
import 'package:fostr/widgets/Layout.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/Helpers.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:fostr/widgets/Loader.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({Key? key}) : super(key: key);

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> with FostrTheme {
  final UserService _userService = GetIt.I<UserService>();

  final nameForm = GlobalKey<FormState>();
  final passwordForm = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool isExists = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.userType == UserType.CLUBOWNER) {
        nameController.value =
            TextEditingValue(text: auth.user?.bookClubName ?? "");
      } else {
        nameController.value = TextEditingValue(text: auth.user?.name ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Layout(
      child: Stack(
        children: [
          Padding(
            padding: paddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 14.h,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("Details",
                      style: h1.copyWith(
                        fontSize: 24.sp,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please enter your details",
                  style: h2.copyWith(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 9.h,
                ),
                Form(
                  key: nameForm,
                  child: Column(
                    children: [
                      InputField(
                        onEditingCompleted: () {
                          FocusScope.of(context).nextFocus();
                        },
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            if (auth.userType == UserType.CLUBOWNER) {
                              return "Enter a Book Club name";
                            } else {
                              return "Enter a name";
                            }
                          }
                        },
                        hintText: (auth.userType == UserType.CLUBOWNER)
                            ? "Enter Book Club name"
                            : "Enter your name",
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (auth.user!.userName.isEmpty)
                          ? InputField(
                              onEditingCompleted: () {
                                FocusScope.of(context).nextFocus();
                              },
                              onChange: (value) => checkUsername(),
                              controller: usernameController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!Validator.isUsername(value)) {
                                    return "Username is not valid";
                                  }
                                  if (isExists) {
                                    return "Username already exists";
                                  }
                                } else {
                                  return "Enter a user name";
                                }
                              },
                              // controller: _controller,
                              hintText: "Username",
                              keyboardType: TextInputType.text,
                            )
                          : SizedBox.fromSize(),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 111),
                  child: PrimaryButton(
                    text: "Save",
                    onTap: () async {
                      await checkUsername();
                      if (nameForm.currentState!.validate()) {
                        var user = auth.user!;
                        var newUser;
                        if (user.createdOn == user.lastLogin) {
                          newUser = User(
                              id: user.id,
                              userName:
                                  usernameController.text.trim().toLowerCase(),
                              userType: user.userType,
                              createdOn: user.createdOn,
                              lastLogin: user.lastLogin,
                              invites: user.invites);
                        } else {
                          newUser = user;
                        }
                        if (auth.userType == UserType.CLUBOWNER) {
                          newUser.bookClubName = nameController.text.trim();
                        } else {
                          newUser.name = nameController.text.trim();
                        }
                        auth.addUserDetails(newUser).then((value) {
                          if (auth.userType == UserType.USER) {
                            FostrRouter.removeUntillAndGoto(context,
                                Routes.userDashboard, (route) => false);
                          } else if (auth.userType == UserType.CLUBOWNER) {
                            Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Dashboard()),
                                (route) => false);
                          }
                        }).catchError((e) {
                          print(e);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Loader(
            isLoading: auth.isLoading,
          )
        ],
      ),
    );
  }

  Future<void> checkUsername({String? value}) async {
    setState(() {
      isExists = false;
    });
    if (usernameController.text.isNotEmpty) {
      var isExists = await _userService
          .checkUserName(usernameController.text.trim().toLowerCase());
      setState(() {
        this.isExists = isExists;
      });
    }
    if (nameForm.currentState!.validate()) {
      setState(() {
        isExists = false;
      });
    }
  }
}
