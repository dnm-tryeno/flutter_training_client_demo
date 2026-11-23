import 'package:flutter/material.dart';

class DigitalSignaturePad extends StatefulWidget {
  final ValueChanged<bool>? onSignatureChanged;

  const DigitalSignaturePad({
    super.key,
    this.onSignatureChanged,
  });

  @override
  State<DigitalSignaturePad> createState() => _DigitalSignaturePadState();
}

class _DigitalSignaturePadState extends State<DigitalSignaturePad> {
  final List<Offset?> _points = [];

  void _clear() {
    setState(() {
      _points.clear();
    });
    widget.onSignatureChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Subtle background guide line
              Positioned(
                left: 20,
                right: 20,
                bottom: 35,
                child: Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              const Positioned(
                left: 20,
                bottom: 12,
                child: Text(
                  'Sign inside box / बॉक्स के अंदर हस्ताक्षर करें',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onPanStart: (details) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final localPosition = renderBox.globalToLocal(details.globalPosition);
                    setState(() {
                      _points.add(localPosition);
                    });
                    widget.onSignatureChanged?.call(true);
                  }
                },
                onPanUpdate: (details) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final localPosition = renderBox.globalToLocal(details.globalPosition);
                    setState(() {
                      _points.add(localPosition);
                    });
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    _points.add(null);
                  });
                },
                child: CustomPaint(
                  painter: _SignaturePainter(points: _points),
                  size: Size.infinite,
                ),
              ),
              if (_points.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20, color: Colors.grey),
                    tooltip: 'Clear Signature',
                    onPressed: _clear,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
