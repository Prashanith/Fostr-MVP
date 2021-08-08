import 'package:flutter/material.dart';
import 'package:fostr/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRoom extends StatefulWidget {
  static final String id = "CreateRoom";

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom]
          )
        ),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.02),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.05),
                child: Text("Ongoing Rooms"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height*0.025,
                      ),
                      child: Card(
                        color: Colors.blue,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        elevation: 10,
                        shadowColor: Colors.black,
                        child: Container(),
                        // child: CachedNetworkImage(
                        //   imageUrl: imagesSource[1],
                        //   imageBuilder: (context,imageProvider) => Container(
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(image: imageProvider,fit: BoxFit.cover,
                        //           colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height*0.05,
                        right: MediaQuery.of(context).size.height*0.05,
                        bottom: MediaQuery.of(context).size.height*0.05,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cristiano Ronaldo",
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.height*0.03,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Cristiano Ronaldo's stunning overhead kick for Real Madrid. Ronaldo lit up the Champions League quarter-final first-leg tie against Juventus with his remarkable bicycle kick to put Madrid 2-0 up and in a commanding position to progress to the semi-finals.",
                            style: GoogleFonts.varelaRound(
                              fontWeight: FontWeight.w300,
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: MediaQuery.of(context).size.height*0.05,
                      child: Chip(
                        label: Text("Reading Room", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.blue,
                        shape: StadiumBorder(side: BorderSide(color: Colors.white)),
                      )
                    ),
                  ]
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.05),
            Column(
              children: [
                FloatingActionButton.extended(
                  label: Text("Start a Room"),
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
