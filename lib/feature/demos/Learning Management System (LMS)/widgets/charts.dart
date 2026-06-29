import 'package:flutter/material.dart';

import '../theme.dart';

/// Smooth line chart used for "Student Score Trend".
/// Mirrors the reference screenshot (curved blue line with dot markers).
class ScoreTrendChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double maxY;

  const ScoreTrendChart({
    super.key,
    required this.values,
    required this.labels,
    this.maxY = 180,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: CustomPaint(
        painter: _LineChartPainter(values, labels, maxY),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxY;
  _LineChartPainter(this.values, this.labels, this.maxY);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const bottomPad = 24.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad;

    final gridPaint = Paint()
      ..color = LmsColors.divider
      ..strokeWidth = 1;
    final axisText = TextStyle(color: LmsColors.textSecondary, fontSize: 10);

    // Horizontal grid lines + y labels (0, 45, 90, 135, 180).
    const ySteps = 4;
    for (int i = 0; i <= ySteps; i++) {
      final y = chartH - (chartH / ySteps) * i;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
      final label = (maxY / ySteps * i).round().toString();
      final tp = TextPainter(
        text: TextSpan(text: label, style: axisText),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad - tp.width - 6, y - tp.height / 2));
    }

    Offset pointAt(int i) {
      final x = leftPad + (chartW / (values.length - 1)) * i;
      final y = chartH - (values[i] / maxY) * chartH;
      return Offset(x, y);
    }

    // Smooth curve via Catmull-Rom -> cubic bezier.
    final path = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (int i = 0; i < values.length - 1; i++) {
      final p0 = pointAt(i == 0 ? i : i - 1);
      final p1 = pointAt(i);
      final p2 = pointAt(i + 1);
      final p3 = pointAt(i + 2 >= values.length ? i + 1 : i + 2);
      final c1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final c2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF38AEEF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Dot markers.
    final dotFill = Paint()..color = Colors.white;
    final dotStroke = Paint()
      ..color = const Color(0xFF38AEEF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (int i = 0; i < values.length; i++) {
      final p = pointAt(i);
      canvas.drawCircle(p, 5, dotFill);
      canvas.drawCircle(p, 5, dotStroke);
    }

    // X labels.
    for (int i = 0; i < labels.length; i++) {
      if (labels[i].isEmpty) continue;
      final p = pointAt(i);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: axisText),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, chartH + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.values != values || old.maxY != maxY;
}

/// Horizontal bar chart for "Subject-wise Performance".
class SubjectBarChart extends StatelessWidget {
  final List<MapEntry<String, double>> data;
  final double maxValue;
  const SubjectBarChart({super.key, required this.data, this.maxValue = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final e in data)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    e.key,
                    style: const TextStyle(
                      fontSize: 13,
                      color: LmsColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      return Stack(
                        children: [
                          Container(
                            height: 22,
                            decoration: BoxDecoration(
                              color: LmsColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            height: 22,
                            width: c.maxWidth * (e.value / maxValue),
                            decoration: BoxDecoration(
                              color: LmsColors.accentCyan,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 32,
                  child: Text(
                    e.value.round().toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: LmsColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
