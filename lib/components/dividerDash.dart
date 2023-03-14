import 'package:flutter/material.dart';

class DashedDividerPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;

  DashedDividerPainter({
    this.strokeWidth = 1,
    this.color = Colors.grey,
    this.gap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final max = size.width;
    final dashWidth = strokeWidth * gap;
    final dashSpace = strokeWidth * gap;
    final dashHeight = size.height;
    final dashCount = (max / (2 * dashWidth + dashSpace)).floor();
    final startX = size.width / 2 - (dashCount / 2 * dashWidth * 2 + dashCount / 2 * dashSpace);

    for (int i = 0; i < dashCount; i++) {
      final dx1 = startX + i * (dashWidth * 2 + dashSpace);
      final dy1 = 0.0;
      final dx2 = startX + dashWidth + i * (dashWidth * 2 + dashSpace);
      final dy2 = dashHeight;
      canvas.drawLine(Offset(dx1, dy1), Offset(dx2, dy2), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
