import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/core/data.dart';
import 'package:fostr/core/functions.dart';
import 'package:fostr/models/UserModel/User.dart';
import 'package:fostr/pages/user/HomePage.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/FilePicker.dart';
import 'package:fostr/services/StorageService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnterRoomDetails extends StatefulWidget {
  @override
  _EnterRoomDetailsState createState() => _EnterRoomDetailsState();
}

class _EnterRoomDetailsState extends State<EnterRoomDetails> with FostrTheme {
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now()) +
      " " +
      DateFormat.Hm().format(DateTime.now());
  TextEditingController eventNameTextEditingController =
      new TextEditingController();
  TextEditingController withTextEditingController = new TextEditingController();
  TextEditingController addGuestTextEditingController =
      new TextEditingController();
  // TextEditingController dateTextEditingController = new TextEditingController();
  // TextEditingController timeTextEditingController = new TextEditingController();
  TextEditingController agendaTextEditingController =
      new TextEditingController();
  String image = "Select Image", imageUrl = "";
  bool isLoading = false, scheduling = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    print(user.userName);
    return Material(
      color: gradientBottom,
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
        child: ListView(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height*0.03,
                  // ),
                  // Text(
                  //   'Schedule a Room',
                  //   style: h1
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SingleChildScrollView(
                    //key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: eventNameTextEditingController,
                          style: h2,
                          decoration: InputDecoration(
                            hintText: "Event Name",
                            hintStyle: TextStyle(
                              color: Color(0xff476747),
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        TextFormField(
                          controller: withTextEditingController,
                          style: h2,
                          decoration: InputDecoration(
                            hintText: "With",
                            hintStyle: TextStyle(
                              color: Color(0xff476747),
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        TextFormField(
                          controller: addGuestTextEditingController,
                          style: h2,
                          decoration: InputDecoration(
                            hintText: "Add a Co-host Guest",
                            hintStyle: TextStyle(
                              color: Color(0xff476747),
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        TextFormField(
                          controller: agendaTextEditingController,
                          style: h2,
                          decoration: InputDecoration(
                            hintText: "Agenda for the meeting is...",
                            hintStyle: TextStyle(
                              color: Color(0xff476747),
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(image, style: h2, overflow: TextOverflow.clip),
                            Spacer(),
                            isLoading
                                ? CircularProgressIndicator(
                                    color: Color(0xff476747),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        final file = await Files.getFile();
                                        if (file['file'] != null) {
                                          imageUrl =
                                              await Storage.saveRoomImage(
                                                  file,
                                                  eventNameTextEditingController
                                                      .text);
                                          setState(() {
                                            isLoading = false;
                                            image = file['file']
                                                .toString()
                                                .substring(
                                                    file['file']
                                                            .toString()
                                                            .lastIndexOf('/') +
                                                        1,
                                                    file['file']
                                                            .toString()
                                                            .length -
                                                        1);
                                          });
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: Color(0xff476747),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  scheduling
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: Text('Schedule Room'),
                          onPressed: () {
                            _createChannel(context, user);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff94B5AC)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createChannel(context, User user) async {
    setState(() {
      scheduling = true;
    });
    var roomToken = await getToken(eventNameTextEditingController.text);
    // Add new data to Firestore collection
    await roomCollection
      .doc(user.id)
      .set({
        'id': user.id
      });
    await roomCollection
        .doc(user.id)
        .collection("rooms")
        .doc(eventNameTextEditingController.text)
        .set({
      'participantsCount': 0,
      'speakersCount': 0,
      'title': '${eventNameTextEditingController.text}',
      'agenda': '${agendaTextEditingController.text}',
      'image': imageUrl,
      'dateTime': '$now',
      // 'dateTime': dateTextEditingController.text + " " + timeTextEditingController.text,
      'roomCreator': user.userName,
      'token': roomToken.toString(),
      'id': user.id
      // });
      // await roomCollection
      //   .doc(user.id)
      //   .collection("rooms")
      //   .doc(eventNameTextEditingController.text)
      //   .collection("speakers")
      //   .doc(user.userName)
      //   .set({
      //     'username': user.userName,
      //     'name': user.name,
      //     'profileImage': user.userProfile?.profileImage ?? "image",
    }).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserDashboard())));
  }
}
