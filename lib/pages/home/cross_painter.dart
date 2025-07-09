import 'package:flutter/material.dart';

class CrossPainter extends CustomPainter {
  const CrossPainter();
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    // Draw first diagonal line (top-left to bottom-right)
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    // Draw second diagonal line (top-right to bottom-left)
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return false;
  }
}