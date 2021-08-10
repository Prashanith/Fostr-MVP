import 'package:flutter/material.dart';
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
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now()) + " " + DateFormat.Hm().format(DateTime.now());
  TextEditingController eventNameTextEditingController = new TextEditingController();
  TextEditingController withTextEditingController = new TextEditingController();
  TextEditingController addGuestTextEditingController = new TextEditingController();
  // TextEditingController dateTextEditingController = new TextEditingController();
  // TextEditingController timeTextEditingController = new TextEditingController();
  TextEditingController agendaTextEditingController = new TextEditingController();
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
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom]
          ),
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(32),
            topEnd: Radius.circular(32),
          ),
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
                  height: MediaQuery.of(context).size.height*0.05,
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
                          // TextFormField(
                          //   controller: imageTextEditingController,
                          //   style: TextStyle(
                          //     color: Colors.teal.shade700,
                          //     fontSize: MediaQuery.of(context).size.height*0.045,
                          //   ),
                          //   decoration: InputDecoration(
                          //     hintText: "Image",
                          //     hintStyle: TextStyle(
                          //       color: Color(0xff476747),
                          //     ),
                          //     border: InputBorder.none,
                          //   ),
                          //   textInputAction: TextInputAction.done,
                          //   onEditingComplete: () =>
                          //       FocusScope.of(context).unfocus(),
                          // ),
                          Text(image,
                            style: h2,
                            overflow: TextOverflow.clip
                          ),
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
                                  if (file != null) {
                                    imageUrl = await Storage.saveRoomImage(file, eventNameTextEditingController.text);
                                    setState(() {
                                      isLoading = false;
                                      image = file['file'].toString().substring(file['file'].toString().lastIndexOf('/') + 1, file['file'].toString().length - 1);
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
                  height: MediaQuery.of(context).size.height*0.03,
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3, vertical: SizeConfig.blockSizeVertical*2),
                //   decoration: BoxDecoration(
                //       color: Color(0xffe9ffee),
                //       borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*5),),
                //   child: Column(
                //     children: [
                //       SingleChildScrollView(
                //         //key: formKey,
                //         child: Column(
                //           children: [
                //             // TextFormField(
                //             //   controller: dateTextEditingController,
                //             //   style: TextStyle(
                //             //     color: Colors.teal.shade700,
                //             //     fontSize: MediaQuery.of(context).size.height*0.045,
                //             //   ),
                //             //   decoration: InputDecoration(
                //             //     hintText: "Date",
                //             //     hintStyle: TextStyle(
                //             //       color: Color(0xff476747),
                //             //     ),
                //             //     border: InputBorder.none,
                //             //   ),
                //             //   textInputAction: TextInputAction.next,
                //             //   onEditingComplete: () =>
                //             //       FocusScope.of(context).nextFocus(),
                //             // ),
                            
                //             DateTimePicker(
                //               type: DateTimePickerType.date,
                //               dateMask: 'yyyy/MM/dd',
                //               controller: dateTextEditingController,
                //               // initialValue: Date,
                //               firstDate: DateTime(2000),
                //               lastDate: DateTime(2100),
                //               icon: Icon(Icons.event, color: Color(0xff476747)),
                //               dateLabelText: 'Date',
                //               use24HourFormat: false,
                //               onChanged: (val) => setState(() => dateTextEditingController.text = val),
                //               // validator: (val) {
                //               //   setState(() => _valueToValidate2 = val ?? '');
                //               //   return null;
                //               // },
                //               // onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
                //             ),
                //             Divider(
                //               height: 0.5,
                //               color: Colors.grey,
                //             ),
                //             // TextFormField(
                //             //   controller: timeTextEditingController,
                //             //   style: TextStyle(
                //             //     color: Colors.teal.shade700,
                //             //     fontSize: MediaQuery.of(context).size.height*0.045,
                //             //   ),
                //             //   decoration: InputDecoration(
                //             //     hintText: "Time",
                //             //     hintStyle: TextStyle(
                //             //       color: Color(0xff476747),
                //             //     ),
                //             //     border: InputBorder.none,
                //             //   ),
                //             //   textInputAction: TextInputAction.next,
                //             //   onEditingComplete: () =>
                //             //       FocusScope.of(context).nextFocus(),
                //             // ),

                //             DateTimePicker(
                //               type: DateTimePickerType.time,
                //               controller: timeTextEditingController,
                //               icon: Icon(Icons.access_time, color: Color(0xff476747)),
                //               timeLabelText: "Time",
                //               // use24HourFormat: false,
                //               onChanged: (val) => setState(() => timeTextEditingController.text = val),
                //               // validator: (val) {
                //               //   setState(() => _valueToValidate4 = val ?? '');
                //               //   return null;
                //               // },
                //               // onSaved: (val) => setState(() => _valueSaved4 = val ?? ''),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: SizeConfig.blockSizeVertical*3,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.03,
                ),
                scheduling
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    child: Text('Schedule Room'),
                    onPressed: () {
                      _createChannel(context, user);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xff94B5AC)),
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
        // .doc(dateTextEditingController.text +
        //     " " +
        //     timeTextEditingController.text)
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
    });
    await roomCollection
        // .doc(dateTextEditingController.text +
        //     " " +
        //     timeTextEditingController.text)
        .doc(eventNameTextEditingController.text)
        .collection("speakers")
        .doc(user.userName)
        .set({
      'username': user.userName,
      'name': user.name,
      'profileImage': user.userProfile!.profileImage ?? "image",
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => OngoingRoom())));
  }
}