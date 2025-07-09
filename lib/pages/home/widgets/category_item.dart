import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home/cross_painter.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
      ),
      child: const CustomPaint(
        painter: CrossPainter(),
      ),
    );
  }
}