import 'package:flutter/material.dart';

class WhatsAppIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WhatsAppIcon({
    super.key,
    this.size = 28,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WhatsAppPainter(color: color),
    );
  }
}

class _WhatsAppPainter extends CustomPainter {
  final Color color;

  _WhatsAppPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..isAntiAlias = true;

    // Speech bubble outline with tail
    final bubblePath = Path();
    bubblePath.moveTo(12.04, 2.0);
    bubblePath.cubicTo(6.58, 2.0, 2.13, 6.45, 2.13, 11.91);
    bubblePath.cubicTo(2.13, 13.66, 2.59, 15.36, 3.45, 16.86);
    bubblePath.lineTo(2.05, 22.0);
    bubblePath.lineTo(7.30, 20.62);
    bubblePath.cubicTo(8.75, 21.41, 10.38, 21.83, 12.04, 21.83);
    bubblePath.cubicTo(17.50, 21.83, 21.95, 17.38, 21.95, 11.91);
    bubblePath.cubicTo(21.95, 9.26, 20.92, 6.77, 19.05, 4.90);
    bubblePath.cubicTo(17.18, 3.03, 14.69, 2.0, 12.04, 2.0);
    bubblePath.close();

    // Phone handset inside
    final phonePath = Path();
    phonePath.moveTo(17.47, 14.38);
    phonePath.cubicTo(17.17, 14.23, 15.70, 13.51, 15.43, 13.41);
    phonePath.cubicTo(15.16, 13.31, 14.96, 13.26, 14.76, 13.56);
    phonePath.cubicTo(14.56, 13.86, 13.99, 14.53, 13.81, 14.73);
    phonePath.cubicTo(13.64, 14.93, 13.46, 14.95, 13.16, 14.80);
    phonePath.cubicTo(12.86, 14.65, 11.89, 14.33, 10.74, 13.31);
    phonePath.cubicTo(9.84, 12.51, 9.24, 11.53, 9.07, 11.23);
    phonePath.cubicTo(8.90, 10.93, 9.05, 10.77, 9.20, 10.62);
    phonePath.cubicTo(9.33, 10.48, 9.50, 10.27, 9.65, 10.10);
    phonePath.cubicTo(9.80, 9.93, 9.85, 9.80, 9.95, 9.60);
    phonePath.cubicTo(10.05, 9.40, 10.00, 9.23, 9.92, 9.08);
    phonePath.cubicTo(9.84, 8.93, 9.25, 7.46, 9.00, 6.86);
    phonePath.cubicTo(8.75, 6.26, 8.50, 6.34, 8.33, 6.33);
    phonePath.cubicTo(8.16, 6.32, 7.96, 6.32, 7.76, 6.32);
    phonePath.cubicTo(7.56, 6.32, 7.24, 6.39, 6.96, 6.69);
    phonePath.cubicTo(6.69, 6.99, 5.91, 7.71, 5.91, 9.19);
    phonePath.cubicTo(5.91, 10.66, 6.98, 12.09, 7.13, 12.29);
    phonePath.cubicTo(7.28, 12.49, 9.24, 15.51, 12.24, 16.81);
    phonePath.cubicTo(12.95, 17.12, 13.51, 17.31, 13.94, 17.45);
    phonePath.cubicTo(14.66, 17.68, 15.31, 17.65, 15.83, 17.57);
    phonePath.cubicTo(16.41, 17.48, 17.60, 16.85, 17.85, 16.15);
    phonePath.cubicTo(18.10, 15.45, 18.10, 14.85, 18.02, 14.73);
    phonePath.cubicTo(17.95, 14.61, 17.75, 14.53, 17.47, 14.38);
    phonePath.close();

    // Draw speech bubble outline & filled phone
    canvas.drawPath(bubblePath, strokePaint);
    canvas.drawPath(phonePath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WhatsAppPainter oldDelegate) => oldDelegate.color != color;
}
