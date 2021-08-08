import 'package:flutter/material.dart';
import 'package:fostr/models/UserModel/User.dart';

class DragProfile extends StatefulWidget {
  final Offset offset;
  final bool isSpeaker;
  final User? user;
  DragProfile({required this.offset, required this.isSpeaker, this.user});

  @override
  DragProfileState createState() => DragProfileState();
}

class DragProfileState extends State<DragProfile> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    setState(() {
      position = widget.offset;
    });
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
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ));
  }
}
