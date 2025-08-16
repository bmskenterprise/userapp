import 'package:flutter/material.dart';

class FillOnHoldCircle extends StatefulWidget {
  final VoidCallback onComplete;
  final double size;
  final Color fillColor;

  const FillOnHoldCircle({super.key, required this.onComplete, this.size = 100.0, this.fillColor = Colors.blue,});
  @override
  State<FillOnHoldCircle> createState() => _FillOnHoldCircleState();
}


class _FillOnHoldCircleState extends State<FillOnHoldCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _isHolding = true;
        _controller.forward();
      },
      onTapUp: (_) {
        _handleRelease();
      },
      onTapCancel: () {
        _handleRelease();
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: CircleFillPainter(
          progress: _controller.value,
          fillColor: widget.fillColor,
        ),
      ),
    );
  }

  void _handleRelease() {
    if (_isHolding) {
      _isHolding = false;
      if (_controller.value == 1.0) {
        widget.onComplete();
      } else {
        _controller.reverse();
      }
    }
  }
}

class CircleFillPainter extends CustomPainter {
  final double progress;
  final Color fillColor;

  CircleFillPainter({
    required this.progress,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final borderWidth = 2.0;

    // Draw border circle
    final borderPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, radius - borderWidth / 2, borderPaint);

    // Draw fill if progress > 0
    if (progress > 0) {
      final fillPaint = Paint()
        ..color = fillColor.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      // Calculate the current fill radius based on progress
      final fillRadius = progress * radius;
      canvas.drawCircle(center, fillRadius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(CircleFillPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.fillColor != fillColor;
  }
}