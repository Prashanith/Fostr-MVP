// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fostr/core/data.dart';
// import 'package:fostr/core/functions.dart';
// import 'package:fostr/core/settings.dart';
// import 'package:fostr/models/RoomModel.dart';
// import 'package:fostr/pages/rooms/Minimalist.dart';
// import 'package:fostr/router/router.dart';
// import 'package:fostr/router/routes.dart';
// import 'package:fostr/utils/theme.dart';
// import 'package:fostr/widgets/rooms/OngoingRoomCard.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:permission_handler/permission_handler.dart';

// class OngoingRoom extends StatefulWidget {
//   const OngoingRoom({Key? key}) : super(key: key);

//   @override
//   State<OngoingRoom> createState() => _OngoingRoomState();
// }

// class _OngoingRoomState extends State<OngoingRoom> with FostrTheme {
//   TextEditingController _textFieldController = TextEditingController();
//   RefreshController _refreshController = RefreshController(
//     initialRefresh: false,
//   );

//   @override
//   void initState() {
//     askPermission();
//     super.initState();
//   }

//   askPermission() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   /// Method for refreshing list

//   void _onRefresh() async {
//     await Future.delayed(
//       Duration(milliseconds: 1000),
//     );
//     _refreshController.refreshCompleted();
//   }

//   /// Method for loading list

//   void _onLoading() async {
//     await Future.delayed(
//       Duration(milliseconds: 1000),
//     );
//     _refreshController.loadComplete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final auth = Provider.of<AuthProvider>(context);
//     // final user = auth.user!;
//     return Material(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment(-0.6, -1),
//             end: Alignment(1, 0.6),
//             colors: [
//               Color.fromRGBO(148, 181, 172, 1),
//               Color.fromRGBO(229, 229, 229, 1),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: paddingH + const EdgeInsets.only(top: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // SvgPicture.asset(ICONS + "menu.svg"),
//                         // SizedBox(
//                         //   height: 30,
//                         // ),
//                         Text(
//                           // "Hello, ${user.name} James",
//                           "Hello,  James",
//                           style: h1.apply(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadiusDirectional.only(
//                           topStart: Radius.circular(24),
//                           topEnd: Radius.circular(24),
//                         ),
//                         color: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: ListView(
//                           children: [
//                             SizedBox(
//                               height: 20,
//                             ),
//                             StreamBuilder<QuerySnapshot>(
//                               stream: roomCollection.snapshots(),
//                               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                 // Handling errors from firebase
//                                 if (snapshot.hasError)
//                                   return Center(child: Text('Error: ${snapshot.error}'));

//                                 if (snapshot.hasData && snapshot.data!.docs.length == 0)
//                                   return Center(child: Text('No Ongoing Rooms Yet'));

//                                 return snapshot.hasData
//                                   ? SizedBox(
//                                     height: MediaQuery.of(context).size.height,
//                                     child: SmartRefresher(
//                                         enablePullDown: true,
//                                         controller: _refreshController,
//                                         onRefresh: _onRefresh,
//                                         onLoading: _onLoading,
//                                         child: ListView(
//                                           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                                             return GestureDetector(
//                                               onTap: () async {
//                                                 FostrRouter.goto(context, Routes.theme);
//                                               },
//                                               child: OngoingRoomCard(room: Room.fromJson(document))
//                                             );
//                                           }).toList(),
//                                         ),
//                                       ),
//                                   )
//                                   // Display if still loading data
//                                   : Center(child: CircularProgressIndicator());
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Align(alignment: Alignment.bottomCenter, child: startRoomButton()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget startRoomButton() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: ElevatedButton(
//         child: Text('Start Room'),
//         onPressed: () {
//           _displayTextInputDialog(context);
//           },
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all<OutlinedBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
  
//   Future<void> _displayTextInputDialog(BuildContext context) async {
//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Enter your room name'),
//           content: TextField(
//             onChanged: (value) {
//               setState(() {
//                 channelName = value;
//               });
//             },
//             onSubmitted: (value) {
//               setState(() {
//                 channelName = value;
//               });
//             },
//             controller: _textFieldController,
//             decoration: InputDecoration(hintText: "Room name"),
//           ),
//           actions: <Widget>[
//             OutlinedButton(
//               child: Text('CANCEL', style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             FlatButton(
//               color: Colors.green,
//               textColor: Colors.white,
//               child: Text('OK'),
//               onPressed: () async {
//                 await _createChannel(context);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       });
//   }

//   _createChannel(context) async {
//     var roomToken = await getToken(channelName);
//     // Add new data to Firestore collection
//     await roomCollection.doc(channelName).set({
//       'participantsCount': 0,
//       'speakersCount': 1,
//       'title': '$channelName',
//       'roomCreator': profileData['username'],
//       'token': roomToken.toString(),
//     });
//     await roomCollection
//         .doc(channelName)
//         .collection("speakers")
//         .doc(profileData['username'])
//         .set({
//       'username': profileData['username'],
//       'name': profileData['name'],
//       'profileImage': profileData['profileImage'],
//     }).then(
//       (value) => Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Minimalist(
//             room: Room(
//               title: '$channelName',
//               // users: [myProfile],
//               participantsCount: 1,
//               roomCreator: profileData['username'],
//               speakersCount: 1,
//               token: roomToken.toString(),
//             ),
//             // Pass user role
//             role: ClientRole.Broadcaster,
//           ),
//         ),
//       ),
//     );
//   }
// }
