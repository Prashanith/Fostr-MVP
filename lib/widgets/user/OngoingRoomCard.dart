import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostr/core/constants.dart';
import 'package:fostr/utils/theme.dart';

import 'BookmarkContainer.dart';

class OngoingRoomCard extends StatelessWidget with FostrTheme {
  OngoingRoomCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff9BC8B1),
                    Color(0xffA5C5BD),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 16,
                    color: Colors.black.withOpacity(0.25),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                ICONS + "people.svg",
                                height: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "250",
                                style: h2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              SvgPicture.asset(
                                ICONS + "mic.svg",
                                height: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "5",
                                style: h2.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "by Indian Book Club",
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 11,
                              fontFamily: "Lato",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "Autobiography of a Yogi",
                    style: h2.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Autobiography of a Yogi is an autobiography of Paramahansa Yogananda. Paramahansa Yogananda was born as Mukunda Lal Ghosh in Gorakhpur, India, into a Bengali Hindu family.",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: BookmarkContainer(),
          ),
        ],
      ),
    );
  }
}
