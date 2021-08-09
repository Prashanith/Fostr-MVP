import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/models/RoomModel.dart';
import 'package:fostr/pages/rooms/EnterRoomDetails.dart';
import 'package:fostr/pages/rooms/SelectTheme.dart';
import 'package:fostr/providers/AuthProvider.dart';
import 'package:fostr/utils/Theme.dart';
import 'package:provider/provider.dart';

class RoomDetails extends StatelessWidget with FostrTheme {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(1, 0.6),
            colors: [
              Color.fromRGBO(148, 181, 172, 1),
              Color.fromRGBO(229, 229, 229, 1),
            ],
          ),
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(32),
            topEnd: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: paddingH + const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SvgPicture.asset(ICONS + "menu.svg"),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    (user.name == "")
                      ? Text(
                        "Hello, User",
                        style: h1.apply(color: Colors.white),
                      )
                      : Text(
                        "Hello, ${user.name}",
                        style: h1.apply(color: Colors.white),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(32),
                      topEnd: Radius.circular(32),
                    ),
                    color: Colors.white,
                  ),
                  child: EnterRoomDetails(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
