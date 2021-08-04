import 'package:flutter/material.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/onboarding/Layout.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/UserService.dart';
import 'package:fostr/utils/Helpers.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/widgets/Buttons.dart';
import 'package:fostr/widgets/InputField.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

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
      child: Padding(
        padding: paddingH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 140,
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text("Details", style: h1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please enter your details",
              style: h2,
            ),
            SizedBox(
              height: 90,
            ),
            Form(
              key: nameForm,
              child: Column(
                children: [
                  InputField(
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
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: passwordForm,
                    child: Column(
                      children: [
                        InputField(
                          controller: passwordController,
                          hintText: "Password",
                          isPassword: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InputField(
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (passwordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              return "Password dose not match";
                            }
                          },
                          isPassword: true,
                          hintText: "Confirm password",
                        ),
                      ],
                    ),
                  ),
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
                  if (nameForm.currentState!.validate() &&
                      passwordForm.currentState!.validate()) {
                    if (auth.email != null) {
                      await auth.signupWithEmailPassword(auth.email!,
                          passwordController.text.trim(), auth.userType!);
                    }
                    var user = auth.user!;
                    var newUser = User(
                        id: user.id,
                        name: "",
                        userName: usernameController.text.trim().toLowerCase(),
                        userType: user.userType,
                        createdOn: user.createdOn,
                        lastLogin: user.lastLogin,
                        invites: user.invites);

                    auth
                        .addUserDetails(newUser, passwordController.text.trim())
                        .then((value) {
                      print("done");
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
