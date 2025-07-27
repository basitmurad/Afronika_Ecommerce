import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularBarProgressIndicator extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double? progress; // null for infinite animation, 0.0-1.0 for progress
  final Duration animationDuration;
  final bool showGradient;

  const CircularBarProgressIndicator({
    Key? key,
    this.size = 80.0,
    this.primaryColor = Colors.yellow,
    this.secondaryColor = Colors.teal,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 8.0,
    this.progress,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.showGradient = true,
  }) : super(key: key);

  @override
  _CircularBarProgressIndicatorState createState() =>
      _CircularBarProgressIndicatorState();
}

class _CircularBarProgressIndicatorState
    extends State<CircularBarProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.progress == null) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularBarProgressPainter(
              animationValue: widget.progress ?? _animation.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              backgroundColor: widget.backgroundColor,
              strokeWidth: widget.strokeWidth,
              isIndeterminate: widget.progress == null,
              showGradient: widget.showGradient,
            ),
          );
        },
      ),
    );
  }
}

class CircularBarProgressPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double strokeWidth;
  final bool isIndeterminate;
  final bool showGradient;

  CircularBarProgressPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.isIndeterminate,
    required this.showGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Create gradient or solid color paint
    Paint progressPaint;

    if (showGradient) {
      progressPaint = Paint()
        ..shader = SweepGradient(
          colors: [primaryColor, secondaryColor, primaryColor],
          stops: [0.0, 0.5, 1.0],
          startAngle: -math.pi / 2,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else {
      progressPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }

    if (isIndeterminate) {
      // Infinite animation - rotating arc
      final sweepAngle = math.pi * 1.5; // 270 degrees
      final startAngle = (animationValue * 2 * math.pi) - math.pi / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    } else {
      // Progress-based animation
      final sweepAngle = animationValue * 2 * math.pi;
      final startAngle = -math.pi / 2; // Start from top

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Add a glowing dot at the end of progress
      if (animationValue > 0) {
        final endAngle = startAngle + sweepAngle;
        final dotCenter = Offset(
          center.dx + radius * math.cos(endAngle),
          center.dy + radius * math.sin(endAngle),
        );

        final dotPaint = Paint()
          ..color = secondaryColor
          ..style = PaintingStyle.fill;

        canvas.drawCircle(dotCenter, strokeWidth / 2, dotPaint);

        // Add glow effect
        final glowPaint = Paint()
          ..color = secondaryColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(dotCenter, strokeWidth, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CircularBarProgressPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}

// Example usage widget
class CircularBarProgressExample extends StatefulWidget {
  @override
  _CircularBarProgressExampleState createState() => _CircularBarProgressExampleState();
}

class _CircularBarProgressExampleState extends State<CircularBarProgressExample> {
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Circular Bar Progress'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Infinite loading indicator
            Column(
              children: [
                Text(
                  'Infinite Loading',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CircularBarProgressIndicator(
                  size: 100,
                  primaryColor: Colors.yellow.shade600,
                  secondaryColor: Colors.teal.shade600,
                  backgroundColor: Colors.grey.shade400,
                  strokeWidth: 10,
                ),
              ],
            ),

            // Progress-based indicator with gradient
            Column(
              children: [
                Text(
                  'Progress: ${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CircularBarProgressIndicator(
                  size: 120,
                  primaryColor: Colors.yellow.shade700,
                  secondaryColor: Colors.teal.shade700,
                  backgroundColor: Colors.grey.shade300,
                  strokeWidth: 12,
                  progress: progress,
                  showGradient: true,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Slider(
                    value: progress,
                    onChanged: (value) => setState(() => progress = value),
                    activeColor: Colors.teal,
                    inactiveColor: Colors.yellow.shade200,
                  ),
                ),
              ],
            ),

            // Different variations
            Column(
              children: [
                Text(
                  'Different Styles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Solid yellow
                    CircularBarProgressIndicator(
                      size: 70,
                      primaryColor: Colors.yellow.shade600,
                      secondaryColor: Colors.yellow.shade800,
                      backgroundColor: Colors.grey.shade300,
                      strokeWidth: 8,
                      progress: 0.75,
                      showGradient: false,
                    ),
                    // Solid teal
                    CircularBarProgressIndicator(
                      size: 70,
                      primaryColor: Colors.teal.shade600,
                      secondaryColor: Colors.teal.shade800,
                      backgroundColor: Colors.grey.shade300,
                      strokeWidth: 8,
                      progress: 0.5,
                      showGradient: false,
                    ),
                    // Gradient mix
                    CircularBarProgressIndicator(
                      size: 70,
                      primaryColor: Colors.yellow.shade400,
                      secondaryColor: Colors.teal.shade400,
                      backgroundColor: Colors.grey.shade300,
                      strokeWidth: 6,
                      progress: 0.9,
                      showGradient: true,
                    ),
                  ],
                ),
              ],
            ),

            // Thin stroke version
            Column(
              children: [
                Text(
                  'Thin Elegant Style',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CircularBarProgressIndicator(
                  size: 90,
                  primaryColor: Colors.amber.shade600,
                  secondaryColor: Colors.teal.shade500,
                  backgroundColor: Colors.grey.shade300,
                  strokeWidth: 4,
                  progress: 0.65,
                  showGradient: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}