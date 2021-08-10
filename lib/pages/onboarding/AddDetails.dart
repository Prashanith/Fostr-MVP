import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isExists = false;

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
                  child: InputField(
                    onChange: checkUsername,
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
                        var newUser = User(
                            id: user.id,
                            name: "",
                            userName:
                                usernameController.text.trim().toLowerCase(),
                            userType: user.userType,
                            createdOn: user.createdOn,
                            lastLogin: user.lastLogin,
                            invites: user.invites);

                        auth.addUserDetails(newUser).then((value) {
                          print("done");
                          if (user.lastLogin == user.createdOn &&
                              user.userType == UserType.USER) {
                            FostrRouter.removeUntillAndGoto(
                                context, Routes.quizPage, (route) => false);
                          } else if (auth.userType == UserType.CLUBOWNER ) {
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

  Future<void> checkUsername() async {
    setState(() {
      isExists = false;
    });
    if (usernameController.text.isNotEmpty &&
        nameForm.currentState!.validate()) {
      var isExists =
          await _userService.checkUserName(usernameController.text.trim());
      setState(() {
        this.isExists = isExists;
      });
    }
    if (!nameForm.currentState!.validate()) {
      setState(() {
        isExists = false;
      });
    }
  }
}
