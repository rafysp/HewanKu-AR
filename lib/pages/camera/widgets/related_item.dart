import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/camera/widgets/cross_painter.dart';

class RelatedItem extends StatelessWidget {
  const RelatedItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: CustomPaint(painter: CrossPainter()),
    );
  }
}
