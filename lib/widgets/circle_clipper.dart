import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Creates a path with an oval that fills the given size
    path.addArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, -size.height / 6),
        radius: size.width / 1.5,
      ),
      0,
      2 * 3.14159265358979323846,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
