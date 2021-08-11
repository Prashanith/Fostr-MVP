import 'package:flutter/material.dart';
import 'package:fostr/core/constants.dart';

class BookmarkContainer extends StatelessWidget {
  final String? imgURL;
  BookmarkContainer({Key? key, required this.imgURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imgURL);
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: (imgURL == null)
                    ? Image.asset(IMAGES + "background.png").image
                    : NetworkImage(imgURL!),
                fit: BoxFit.contain)),
        height: 88,
        width: 70,
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(35, 63.5556);
    path_0.lineTo(70, 88);
    path_0.lineTo(70, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(0, 88);
    path_0.lineTo(35, 63.5556);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
