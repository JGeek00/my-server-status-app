import 'package:flutter/material.dart';

class ArcChart extends StatelessWidget {
  final double percentage;
  final int arcWidth;
  final Color color;
  final int size;

  const ArcChart({
    Key? key,
    required this.percentage,
    required this.arcWidth,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: Angle(
            percentage: percentage,
            arcWidth: arcWidth,
            color: color,
            s: size
          ),
        ),
        CustomPaint(
          painter: ArcBase(
            arcWidth: arcWidth,
            color: color,
            s: size
          ),
        ),
      ],
    );
  }
}

class Angle extends CustomPainter {
  final double percentage;
  final int arcWidth;
  final Color color;
  final int s;

  const Angle({
    required this.percentage,
    required this.arcWidth,
    required this.color,
    required this.s,
  });

  static const startAngle = 2.26893;
  static const maxAngle = 4.88692;
  
  @override
  void paint(Canvas canvas, Size size) {
    var arc = Paint()
      ..color = color.withOpacity(1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth.toDouble()
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Offset(-s/2.toDouble(), -s/2.toDouble()) & Size(s.toDouble(), s.toDouble()),
      startAngle,  // start: radians
      (percentage*maxAngle)/100,  // end: radians
      false,
      arc
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ArcBase extends CustomPainter {
  final int arcWidth;
  final Color color;
  final int s;

  const ArcBase({
    required this.arcWidth,
    required this.color,
    required this.s
  });

  static const startAngle = 2.26893;
  static const maxAngle = 4.88692;
  
  @override
  void paint(Canvas canvas, Size size) {
    var base = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth.toDouble()
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Offset(-s/2.toDouble(), -s/2.toDouble()) & Size(s.toDouble(), s.toDouble()),
      startAngle,  // start: radians
      maxAngle,  // end: radians
      false,
      base
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}