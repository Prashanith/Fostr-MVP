import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/pages/user/HomePage.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/services/FilePicker.dart';
import 'package:fostr/services/RoomService.dart';
import 'package:fostr/services/StorageService.dart';
import 'package:fostr/utils/theme.dart';
import 'package:fostr/utils/widget_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterRoomDetails extends StatefulWidget {
  @override
  _EnterRoomDetailsState createState() => _EnterRoomDetailsState();
}

class _EnterRoomDetailsState extends State<EnterRoomDetails>
    with FostrTheme, TickerProviderStateMixin {
  String now = DateFormat('yyyy-MM-dd').format(DateTime.now()) +
      " " +
      DateFormat.Hm().format(DateTime.now());

  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  DateTime _dateTime2 = DateTime.now();
  TimeOfDay _timeOfDay2 = TimeOfDay.now();

  static const List<String> genres = [
    "Action and Adventure",
    "Comic Book",
    "Detective and Mystery",
    "Fantasy",
    "History",
    "Horror",
    "Fiction",
    "Romance",
    "Sci-fi",
    "Suspense",
    "Biography"
  ];

  String value1 = genres[0];
  String value2 = genres[1];

  TextEditingController eventNameTextEditingController =
  new TextEditingController();
  TextEditingController withTextEditingController = new TextEditingController();
  TextEditingController addGuestTextEditingController =
  new TextEditingController();

  // TextEditingController dateTextEditingController = new TextEditingController();
  // TextEditingController timeTextEditingController = new TextEditingController();
  TextEditingController agendaTextEditingController =
  new TextEditingController();
  TextEditingController passController = new TextEditingController();
  String image = "Add a Image (378x 224)", imageUrl = "";
  bool isLoading = false, scheduling = false;

  late TabController _tabController =
  new TabController(vsync: this, length: 1, initialIndex: 0);

  List<bool> isOpen=[false];

  final _formKey = GlobalKey<FormState>();

  final _userCollection = FirebaseFirestore.instance.collection("users");

  void _launchURL(_url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  String imageUrl2 = "";

  TextEditingController adTitle = new TextEditingController();
  TextEditingController adDescription = new TextEditingController();
  TextEditingController redirectLink = new TextEditingController();




  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 40),
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            indicatorPadding: EdgeInsets.all(0),
            tabs: [
              Container(
                height: 45,
                width: double.infinity,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: ElevatedButton.icon(
                  onPressed: () => {
                    setState(() => {_tabController.animateTo(0)})
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.0),
                          )),
                      backgroundColor: _tabController.index == 0
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.white),
                      foregroundColor: _tabController.index == 0
                          ? MaterialStateProperty.all(Colors.white)
                          : MaterialStateProperty.all(Colors.black)),
                  icon: Icon(Icons.mic),
                  label: Text("Room"),
                ),
              ),
              // Container(
              //   height: 45,
              //   margin: EdgeInsets.all(0),
              //   padding: EdgeInsets.all(0),
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: () => {
              //       setState(() => {_tabController.animateTo(1)})
              //     },
              //     style: ButtonStyle(
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(11.0),
              //         )),
              //         backgroundColor: _tabController.index == 1
              //             ? MaterialStateProperty.all(Colors.black)
              //             : MaterialStateProperty.all(Colors.white),
              //         foregroundColor: _tabController.index == 1
              //             ? MaterialStateProperty.all(Colors.white)
              //             : MaterialStateProperty.all(Colors.black)),
              //     icon: Icon(Icons.theater_comedy),
              //     label: Text("Theatre"),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: eventNameTextEditingController,
                                    style: h2,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle:
                                      new TextStyle(color: Colors.grey[600]),
                                      hintText: "Event Name",
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: withTextEditingController,
                                    style: h2,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle:
                                      new TextStyle(color: Colors.grey[600]),
                                      hintText: "Book Name",
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: addGuestTextEditingController,
                                    style: h2,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle:
                                      new TextStyle(color: Colors.grey[600]),
                                      hintText: "Add a Co-Host",
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        borderSide: BorderSide(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     TextButton.icon(
                                  //         style: ButtonStyle(
                                  //           foregroundColor:
                                  //           MaterialStateProperty.all(
                                  //               Colors.black),
                                  //         ),
                                  //         onPressed: () {
                                  //           showDatePicker(
                                  //               context: context,
                                  //               initialDate: _dateTime,
                                  //               firstDate: DateTime.now(),
                                  //               lastDate: DateTime(2040))
                                  //               .then((value) => {
                                  //             setState(() =>
                                  //             {_dateTime = value!})
                                  //           });
                                  //         },
                                  //         icon: Icon(Icons.event),
                                  //         label: Text("Pick Date")),
                                  //     SizedBox(
                                  //       width: 20,
                                  //     ),
                                  //     Expanded(
                                  //       child: Container(
                                  //         height:
                                  //         MediaQuery.of(context).size.height *
                                  //             0.04,
                                  //         child: Center(
                                  //             child: Text(
                                  //                 "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}")),
                                  //         decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(10),
                                  //           ),
                                  //           border: Border.all(
                                  //               color: Colors.grey, width: 0.5),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment.spaceEvenly,
                                  //   children: [
                                  //     TextButton.icon(
                                  //         style: ButtonStyle(
                                  //           foregroundColor:
                                  //           MaterialStateProperty.all(
                                  //               Colors.black),
                                  //         ),
                                  //         onPressed: () {
                                  //           showTimePicker(
                                  //             context: context,
                                  //             initialTime: _timeOfDay,
                                  //           ).then((value) => {
                                  //             setState(() => {
                                  //               _timeOfDay = value!
                                  //                   .replacing(
                                  //                   hour: value
                                  //                       .hourOfPeriod)
                                  //             })
                                  //           });
                                  //         },
                                  //         icon: Icon(Icons.event),
                                  //         label: Text("Pick Time")),
                                  //     SizedBox(
                                  //       width: 20,
                                  //     ),
                                  //     Expanded(
                                  //       child: Container(
                                  //         height:
                                  //         MediaQuery.of(context).size.height *
                                  //             0.04,
                                  //         child: Center(
                                  //             child: Text(
                                  //                 "${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}:${_timeOfDay.period.toString().substring(_timeOfDay.period.toString().length - 2).toUpperCase()}")),
                                  //         decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(10),
                                  //           ),
                                  //           border: Border.all(
                                  //               color: Colors.grey, width: 0.5),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Container(
                                    child: DropdownButton<String>(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                      value: value1,
                                      items: genres.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          value1 = val!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator(
                                        color: Color(0xff476747),
                                      )
                                          : Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (eventNameTextEditingController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                final file =
                                                await Files.getFile();

                                                if (file['file'] != null) {
                                                  try {
                                                    final croppedFile =
                                                    await ImageCropper
                                                        .cropImage(
                                                      sourcePath:
                                                      file['file'].path,
                                                      maxHeight: 150,
                                                      maxWidth: 150,
                                                      aspectRatio:
                                                      CropAspectRatio(
                                                          ratioX: 1,
                                                          ratioY: 1),
                                                    );

                                                    if (croppedFile !=
                                                        null) {
                                                      imageUrl = await Storage
                                                          .saveRoomImage(
                                                          {
                                                            "file":
                                                            croppedFile,
                                                            "ext":
                                                            file["ext"]
                                                          },
                                                          eventNameTextEditingController
                                                              .text);
                                                      setState(() {
                                                        isLoading = false;
                                                        image = file['file']
                                                            .toString()
                                                            .substring(
                                                            file['file']
                                                                .toString()
                                                                .lastIndexOf(
                                                                '/') +
                                                                1,
                                                            file['file']
                                                                .toString()
                                                                .length -
                                                                1);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    }
                                                  } catch (e) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "Image must be less than 700KB",
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      gravity: ToastGravity
                                                          .BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                      gradientBottom,
                                                      textColor:
                                                      Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              } catch (e) {
                                                print(e);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "Event Name is required!",
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                  gradientBottom,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.2,
                                            child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.image_outlined,
                                                      size: 83,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                        "add an image (378x224)"),
                                                  ],
                                                )),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.008,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            scheduling?
                            CircularProgressIndicator()
                                :Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ElevatedButton(
                                //   child: Text(
                                //     'Schedule',
                                //   ),
                                //   onPressed: () async {
                                //     if (eventNameTextEditingController
                                //         .text.isEmpty) {
                                //       Fluttertoast.showToast(
                                //           msg: "Event Name is required!",
                                //           toastLength: Toast.LENGTH_SHORT,
                                //           gravity: ToastGravity.BOTTOM,
                                //           timeInSecForIosWeb: 1,
                                //           backgroundColor: gradientBottom,
                                //           textColor: Colors.white,
                                //           fontSize: 16.0);
                                //     } else {
                                //       setState(() {
                                //         scheduling = true;
                                //       });
                                //       final newUser =
                                //       await GetIt.I<RoomService>()
                                //           .createRoom(
                                //           user,
                                //           eventNameTextEditingController
                                //               .text,
                                //           value1,
                                //           _dateTime,
                                //           _timeOfDay,
                                //           imageUrl,
                                //           passController.text,
                                //           now,
                                //           // adTitle.text,
                                //           // adDescription.text,
                                //           // redirectLink.text,
                                //           // imageUrl2
                                //       );
                                //       auth.refreshUser(newUser);
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   UserDashboard()));
                                //     }
                                //   },
                                //   style: ButtonStyle(
                                //     padding:
                                //     MaterialStateProperty.all<EdgeInsets>(
                                //         EdgeInsets.symmetric(
                                //             horizontal: 30, vertical: 15)),
                                //     backgroundColor: MaterialStateProperty.all(
                                //         Color(0xff2A9D8F)),
                                //     shape: MaterialStateProperty.all<
                                //         OutlinedBorder>(
                                //       RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(30),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (eventNameTextEditingController
                                        .text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Event Name is required!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: gradientBottom,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      setState(() {
                                        scheduling = true;
                                      });
                                      final newUser = await GetIt.I<RoomService>()
                                          .createRoomNow(
                                          user,
                                          eventNameTextEditingController.text,
                                          value1,
                                          imageUrl,
                                          passController.text,
                                          now,
                                      );
                                      auth.refreshUser(newUser);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDashboard()));
                                    }
                                  },
                                  child: const Text("Start Now"),
                                  style: ButtonStyle(
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15)),
                                    backgroundColor: MaterialStateProperty.all(
                                        GlobalColors.signUpSignInButton),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                  ),
                ),
                // Center(
                //   child: Text("Theatre Coming Soon"),
                // )
                // Center(
                //   child: SingleChildScrollView(
                //     child: Container(
                //       padding: EdgeInsets.symmetric(vertical: 20),
                //       alignment: Alignment.topCenter,
                //       child: Column(
                //         children: [
                //           SingleChildScrollView(
                //             //key: formKey,
                //             child: Column(
                //               children: [
                //                 TextField(
                //                   controller: eventNameTextEditingController,
                //                   style: h2,
                //                   decoration: InputDecoration(
                //                     contentPadding: EdgeInsets.symmetric(
                //                         vertical: 1, horizontal: 15),
                //                     border: OutlineInputBorder(
                //                       borderRadius: const BorderRadius.all(
                //                         Radius.circular(15.0),
                //                       ),
                //                     ),
                //                     filled: true,
                //                     hintStyle:
                //                         new TextStyle(color: Colors.grey[600]),
                //                     hintText: "Enter Event Name",
                //                     fillColor: Colors.white,
                //                     enabledBorder: OutlineInputBorder(
                //                       borderRadius:
                //                           BorderRadius.all(Radius.circular(15)),
                //                       borderSide: BorderSide(
                //                           width: 0.5, color: Colors.grey),
                //                     ),
                //                   ),
                //                   textInputAction: TextInputAction.next,
                //                   onEditingComplete: () =>
                //                       FocusScope.of(context).nextFocus(),
                //                 ),
                //                 SizedBox(
                //                   height: 20,
                //                 ),
                //                 TextField(
                //                   controller: withTextEditingController,
                //                   style: h2,
                //                   decoration: InputDecoration(
                //                     contentPadding: EdgeInsets.symmetric(
                //                         vertical: 1, horizontal: 15),
                //                     border: OutlineInputBorder(
                //                       borderRadius: const BorderRadius.all(
                //                         Radius.circular(15.0),
                //                       ),
                //                     ),
                //                     filled: true,
                //                     hintStyle:
                //                         new TextStyle(color: Colors.grey[600]),
                //                     hintText: "Book Name",
                //                     fillColor: Colors.white,
                //                     enabledBorder: OutlineInputBorder(
                //                       borderRadius:
                //                           BorderRadius.all(Radius.circular(15)),
                //                       borderSide: BorderSide(
                //                           width: 0.5, color: Colors.grey),
                //                     ),
                //                   ),
                //                   textInputAction: TextInputAction.next,
                //                   onEditingComplete: () =>
                //                       FocusScope.of(context).nextFocus(),
                //                 ),
                //                 SizedBox(
                //                   height: 20,
                //                 ),
                //                 TextField(
                //                   controller: addGuestTextEditingController,
                //                   style: h2,
                //                   decoration: InputDecoration(
                //                     contentPadding: EdgeInsets.symmetric(
                //                         vertical: 1, horizontal: 15),
                //                     border: OutlineInputBorder(
                //                       borderRadius: const BorderRadius.all(
                //                         Radius.circular(15.0),
                //                       ),
                //                     ),
                //                     filled: true,
                //                     hintStyle:
                //                         new TextStyle(color: Colors.grey[600]),
                //                     hintText: "Add a summary",
                //                     fillColor: Colors.white,
                //                     enabledBorder: OutlineInputBorder(
                //                       borderRadius:
                //                           BorderRadius.all(Radius.circular(15)),
                //                       borderSide: BorderSide(
                //                           width: 0.5, color: Colors.grey),
                //                     ),
                //                   ),
                //                   textInputAction: TextInputAction.next,
                //                   onEditingComplete: () =>
                //                       FocusScope.of(context).nextFocus(),
                //                 ),
                //                 SizedBox(
                //                   height: 20,
                //                 ),
                //                 Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     TextButton.icon(
                //                         style: ButtonStyle(
                //                           foregroundColor:
                //                               MaterialStateProperty.all(
                //                                   Colors.black),
                //                         ),
                //                         onPressed: () {
                //                           showDatePicker(
                //                                   context: context,
                //                                   initialDate: _dateTime2,
                //                                   firstDate: DateTime.now(),
                //                                   lastDate: DateTime(2040))
                //                               .then((value) => {
                //                                     setState(() =>
                //                                         {_dateTime2 = value!})
                //                                   });
                //                         },
                //                         icon: Icon(Icons.event),
                //                         label: Text("Pick Date")),
                //                     SizedBox(
                //                       width: 20,
                //                     ),
                //                     Expanded(
                //                       child: Container(
                //                         height:
                //                             MediaQuery.of(context).size.height *
                //                                 0.04,
                //                         child: Center(
                //                             child: Text(
                //                                 "${_dateTime2.day}/${_dateTime2.month}/${_dateTime2.year}")),
                //                         decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(
                //                             Radius.circular(10),
                //                           ),
                //                           border: Border.all(
                //                               color: Colors.grey, width: 0.5),
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     TextButton.icon(
                //                         style: ButtonStyle(
                //                           foregroundColor:
                //                               MaterialStateProperty.all(
                //                                   Colors.black),
                //                         ),
                //                         onPressed: () {
                //                           showTimePicker(
                //                             context: context,
                //                             initialTime: _timeOfDay2,
                //                           ).then((value) => {
                //                                 setState(() => {
                //                                       _timeOfDay2 = value!
                //                                           .replacing(
                //                                               hour: value
                //                                                   .hourOfPeriod)
                //                                     })
                //                               });
                //                         },
                //                         icon: Icon(Icons.event),
                //                         label: Text("Pick Time")),
                //                     SizedBox(
                //                       width: 20,
                //                     ),
                //                     Expanded(
                //                       child: Container(
                //                         height:
                //                             MediaQuery.of(context).size.height *
                //                                 0.04,
                //                         child: Center(
                //                             child: Text(
                //                                 "${_timeOfDay2.hour.toString().padLeft(2, '0')}:${_timeOfDay2.minute.toString().padLeft(2, '0')}:${_timeOfDay2.period.toString().substring(_timeOfDay2.period.toString().length - 2).toUpperCase()}")),
                //                         decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius: BorderRadius.all(
                //                             Radius.circular(10),
                //                           ),
                //                           border: Border.all(
                //                               color: Colors.grey, width: 0.5),
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(
                //                   height: 20,
                //                 ),
                //                 Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     isLoading
                //                         ? CircularProgressIndicator(
                //                             color: Color(0xff476747),
                //                           )
                //                         : Expanded(
                //                             child: GestureDetector(
                //                               onTap: () async {
                //                                 if (eventNameTextEditingController
                //                                     .text.isNotEmpty) {
                //                                   setState(() {
                //                                     isLoading = true;
                //                                   });
                //                                   try {
                //                                     final file =
                //                                         await Files.getFile();
                //
                //                                     if (file['file'] != null) {
                //                                       try {
                //                                         final croppedFile =
                //                                             await ImageCropper
                //                                                 .cropImage(
                //                                           sourcePath:
                //                                               file['file'].path,
                //                                           maxHeight: 150,
                //                                           maxWidth: 150,
                //                                           aspectRatio:
                //                                               CropAspectRatio(
                //                                                   ratioX: 1,
                //                                                   ratioY: 1),
                //                                         );
                //
                //                                         if (croppedFile !=
                //                                             null) {
                //                                           imageUrl = await Storage
                //                                               .saveRoomImage(
                //                                                   {
                //                                                 "file":
                //                                                     croppedFile,
                //                                                 "ext":
                //                                                     file["ext"]
                //                                               },
                //                                                   eventNameTextEditingController
                //                                                       .text);
                //                                           setState(() {
                //                                             isLoading = false;
                //                                             image = file['file']
                //                                                 .toString()
                //                                                 .substring(
                //                                                     file['file']
                //                                                             .toString()
                //                                                             .lastIndexOf(
                //                                                                 '/') +
                //                                                         1,
                //                                                     file['file']
                //                                                             .toString()
                //                                                             .length -
                //                                                         1);
                //                                           });
                //                                         } else {
                //                                           setState(() {
                //                                             isLoading = false;
                //                                           });
                //                                         }
                //                                       } catch (e) {
                //                                         setState(() {
                //                                           isLoading = false;
                //                                         });
                //                                       }
                //                                     } else {
                //                                       setState(() {
                //                                         isLoading = false;
                //                                       });
                //                                       Fluttertoast.showToast(
                //                                           msg:
                //                                               "Image must be less than 700KB",
                //                                           toastLength: Toast
                //                                               .LENGTH_SHORT,
                //                                           gravity: ToastGravity
                //                                               .BOTTOM,
                //                                           timeInSecForIosWeb: 1,
                //                                           backgroundColor:
                //                                               gradientBottom,
                //                                           textColor:
                //                                               Colors.white,
                //                                           fontSize: 16.0);
                //                                     }
                //                                   } catch (e) {
                //                                     print(e);
                //                                     setState(() {
                //                                       isLoading = false;
                //                                     });
                //                                   }
                //                                 } else {
                //                                   Fluttertoast.showToast(
                //                                       msg:
                //                                           "Event Name is required!",
                //                                       toastLength:
                //                                           Toast.LENGTH_SHORT,
                //                                       gravity:
                //                                           ToastGravity.BOTTOM,
                //                                       timeInSecForIosWeb: 1,
                //                                       backgroundColor:
                //                                           gradientBottom,
                //                                       textColor: Colors.white,
                //                                       fontSize: 16.0);
                //                                 }
                //                               },
                //                               child: Container(
                //                                 height: MediaQuery.of(context)
                //                                         .size
                //                                         .height *
                //                                     0.13,
                //                                 child: Center(
                //                                     child: Column(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment
                //                                           .spaceEvenly,
                //                                   children: [
                //                                     Icon(
                //                                       Icons.image_outlined,
                //                                       size: 83,
                //                                       color: Colors.grey,
                //                                     ),
                //                                     Text(
                //                                         "Add a Image (378x 224)"),
                //                                   ],
                //                                 )),
                //                                 decoration: BoxDecoration(
                //                                   color: Colors.white,
                //                                   borderRadius:
                //                                       BorderRadius.all(
                //                                     Radius.circular(10),
                //                                   ),
                //                                   border: Border.all(
                //                                       color: Colors.grey,
                //                                       width: 0.5),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                   ],
                //                 ),
                //               ],
                //             ),
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Container(
                //             child: DropdownButton<String>(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(8)),
                //               value: value2,
                //               items: genres.map((String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value),
                //                 );
                //               }).toList(),
                //               onChanged: (val) {
                //                 setState(() {
                //                   value2 = val!;
                //                 });
                //               },
                //             ),
                //           ),
                //           SizedBox(
                //             height: MediaQuery.of(context).size.height * 0.03,
                //           ),
                //           SizedBox(
                //             height: MediaQuery.of(context).size.height * 0.03,
                //           ),
                //           scheduling
                //               ? CircularProgressIndicator()
                //               : ElevatedButton(
                //                   child: Text(
                //                     'Schedule',
                //                   ),
                //                   onPressed: () async {
                //                     if (eventNameTextEditingController
                //                         .text.isEmpty) {
                //                       Fluttertoast.showToast(
                //                           msg: "Event Name is required!",
                //                           toastLength: Toast.LENGTH_SHORT,
                //                           gravity: ToastGravity.BOTTOM,
                //                           timeInSecForIosWeb: 1,
                //                           backgroundColor: gradientBottom,
                //                           textColor: Colors.white,
                //                           fontSize: 16.0);
                //                     } else {
                //                       setState(() {
                //                         scheduling = true;
                //                       });
                //                       final newUser =
                //                           await GetIt.I<RoomService>()
                //                               .createRoom(
                //                                   user,
                //                                   eventNameTextEditingController
                //                                       .text,
                //                                   agendaTextEditingController
                //                                       .text,
                //                                   _dateTime2,
                //                                   _timeOfDay2,
                //                                   value2,
                //                                   imageUrl,
                //                                   passController.text,
                //                                   now);
                //                       auth.refreshUser(newUser);
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   UserDashboard()));
                //                     }
                //                   },
                //                   style: ButtonStyle(
                //                     padding:
                //                         MaterialStateProperty.all<EdgeInsets>(
                //                             EdgeInsets.symmetric(
                //                                 horizontal: 30, vertical: 15)),
                //                     backgroundColor: MaterialStateProperty.all(
                //                         Color(0xff2A9D8F)),
                //                     shape: MaterialStateProperty.all<
                //                         OutlinedBorder>(
                //                       RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(30),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration inputDecoration(){
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
        vertical: 1, horizontal: 15),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    filled: true,
    hintStyle:
    new TextStyle(color: Colors.grey[600]),
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
          width: 0.5, color: Colors.grey),
    ),
  );
}
