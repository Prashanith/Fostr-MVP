import 'package:flutter/material.dart';
import 'package:fostr/models/UserModel/RoomUser.dart';
import 'package:fostr/widgets/rooms/Profile.dart';

class DragProfile extends StatefulWidget {
  final Offset offset;
  final bool isSpeaker;
  final RoomUser user;
  // Color? color;
  DragProfile({required this.offset, required this.isSpeaker, required this.user,
  //  this.color
  });

  @override
  DragProfileState createState() => DragProfileState();
}

class DragProfileState extends State<DragProfile> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    // setState(() {
      position = widget.offset;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 200),
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              position += details.delta;
            });
          },
          onPanEnd: (details) {
            print(position);
          },
          // child: Container(
          //   height: 40,
          //   width: 40,
          //   decoration: BoxDecoration(
          //     color: widget.color,
          //     // color: Colors.red,
          //     shape: BoxShape.circle,
          //   ),
          // ),
          child: Profile(user: widget.user, size: 40, isMute: false, isSpeaker: widget.isSpeaker),
        ));
  }
}
