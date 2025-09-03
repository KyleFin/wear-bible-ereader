import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularSlider extends StatefulWidget {
  const CircularSlider({
    required this.value,
    required this.onChanged,
    super.key,
  });
  final double value;
  final ValueChanged<double> onChanged;
  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  bool _isDragging = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final center = Offset(
          context.size!.width / 2,
          context.size!.height / 2,
        );
        final radius = math.min(context.size!.width, context.size!.height) / 2;
        final thumbX = center.dx +
            radius * math.cos(-math.pi / 2 + 2 * math.pi * widget.value);
        final thumbY = center.dy +
            radius * math.sin(-math.pi / 2 + 2 * math.pi * widget.value);
        final thumbPosition = Offset(thumbX, thumbY);
        final touchPosition = details.localPosition;
        // Check if the initial tap is near the thumb
        if ((touchPosition - thumbPosition).distance < 20) {
          // Adjust the distance as needed
          _isDragging = true;
        } else {
          _isDragging = true;
          // If not on the thumb, still start dragging but set the value based on the initial touch
          var angle = math.atan2(
            touchPosition.dy - center.dy,
            touchPosition.dx - center.dx,
          );
          if (angle < -math.pi / 2) {
            angle += 2 * math.pi;
          }
          var newValue = (angle + math.pi / 2) / (2 * math.pi);
          newValue = newValue.clamp(0.0, 1.0);
          widget.onChanged(newValue);
        }
      },
      onPanUpdate: (details) {
        if (_isDragging) {
          final center = Offset(
            context.size!.width / 2,
            context.size!.height / 2,
          );
          final touchPosition = details.localPosition;
          var angle = math.atan2(
            touchPosition.dy - center.dy,
            touchPosition.dx - center.dx,
          );
          if (angle < -math.pi / 2) {
            angle += 2 * math.pi;
          }
          var newValue = (angle + math.pi / 2) / (2 * math.pi);
          newValue = newValue.clamp(0.0, 1.0);
          widget.onChanged(newValue);
        }
      },
      onPanEnd: (details) {
        _isDragging = false;
      },
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _CircularSliderPainter(widget.value),
      ),
    );
  }
}

class _CircularSliderPainter extends CustomPainter {
  _CircularSliderPainter(this.value);
  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
    final thumbX = center.dx + radius * math.cos(startAngle + sweepAngle);
    final thumbY = center.dy + radius * math.sin(startAngle + sweepAngle);
    final thumbPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(thumbX, thumbY), 12, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularSliderPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
