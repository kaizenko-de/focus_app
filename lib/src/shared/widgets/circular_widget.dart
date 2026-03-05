import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularProgressSteps extends StatelessWidget {
  final int currentSteps;
  final int goalSteps;
  final double size;
  final double strokeWidth;

  const CircularProgressSteps({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
    this.size = 300,
    this.strokeWidth = 4, // Much thinner stroke
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentSteps / goalSteps;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: BackgroundCirclePainter(strokeWidth: strokeWidth),
          ),
          // Progress circle with gradient
          CustomPaint(
            size: Size(size, size),
            painter: ProgressCirclePainter(
              progress: progress,
              strokeWidth: strokeWidth,
            ),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Steps number with pink dot
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatSteps(currentSteps),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.only(left: 4, bottom: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF1493), // Deep pink color
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Goal text
              Text(
                'Next Goal: ${_formatSteps(goalSteps)} Steps',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),
              // Steps label
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSteps(int steps) {
    // Format with German-style thousands separator (dot)
    if (steps >= 1000) {
      final thousands = steps ~/ 1000;
      final remainder = steps % 1000;
      return '$thousands.${remainder.toString().padLeft(3, '0')}';
    }
    return steps.toString();
  }
}

class BackgroundCirclePainter extends CustomPainter {
  final double strokeWidth;

  BackgroundCirclePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.1)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Draw three background circles at different radii
    canvas.drawCircle(center, size.width / 2 - 15, paint); // Outer ring
    canvas.drawCircle(center, size.width / 2 - 25, paint); // Middle ring
    canvas.drawCircle(center, size.width / 2 - 35, paint); // Inner ring
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  ProgressCirclePainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw three concentric rings with different radii and progress levels
    _drawProgressRing(
      canvas,
      center,
      size.width / 2 - 15,
      0.87,
      strokeWidth,
    ); // Outer ring - most complete
    _drawProgressRing(
      canvas,
      center,
      size.width / 2 - 25,
      0.65,
      strokeWidth,
    ); // Middle ring - medium complete
    _drawProgressRing(
      canvas,
      center,
      size.width / 2 - 35,
      progress,
      strokeWidth,
    ); // Inner ring - matches current progress
  }

  void _drawProgressRing(
    Canvas canvas,
    Offset center,
    double radius,
    double ringProgress,
    double strokeWidth,
  ) {
    // Create gradient paint for each ring
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 2 * math.pi - math.pi / 2,
      colors: [
        Color(0xFFCCFF00), // Bright lime green
        Color(0xFF9AFF00), // Medium lime green
        Color(0xFFFFFFFF), // White
      ],
      stops: [0.0, 0.6, 1.0],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Calculate sweep angle based on ring progress
    final sweepAngle = 2 * math.pi * ringProgress;
    const startAngle = -math.pi / 2; // Start from top

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
