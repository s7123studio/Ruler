import 'package:flutter/material.dart';

class VerticalRuler extends StatelessWidget {
  final double pixelsPerCm;

  const VerticalRuler({super.key, required this.pixelsPerCm});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(40, MediaQuery.of(context).size.height),
      painter: VerticalRulerPainter(pixelsPerCm: pixelsPerCm),
    );
  }
}

class HorizontalRuler extends StatelessWidget {
  final double pixelsPerCm;

  const HorizontalRuler({super.key, required this.pixelsPerCm});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 40),
      painter: HorizontalRulerPainter(pixelsPerCm: pixelsPerCm),
    );
  }
}

class VerticalRulerPainter extends CustomPainter {
  final double pixelsPerCm;

  VerticalRulerPainter({required this.pixelsPerCm});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1.5;

    final textStyle = TextStyle(
      color: Colors.white70,
      fontSize: 12,
    );

    for (double i = 0; i < size.height; i += pixelsPerCm) {
      final isMajorTick = (i % (pixelsPerCm * 5)) == 0;
      final lineLength = isMajorTick ? 30.0 : 20.0;
      
      canvas.drawLine(
        Offset(size.width - lineLength, i),
        Offset(size.width, i),
        paint,
      );

      if (isMajorTick) {
        final textSpan = TextSpan(
          text: '${(i ~/ pixelsPerCm).toInt()}',
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          Offset(size.width - lineLength - 20, i - 6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HorizontalRulerPainter extends CustomPainter {
  final double pixelsPerCm;

  HorizontalRulerPainter({required this.pixelsPerCm});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white70..strokeWidth = 1.5;
    final textStyle = TextStyle(color: Colors.white70, fontSize: 12);

    for (double i = 0; i < size.width; i += pixelsPerCm) {
      final isMajorTick = (i % (pixelsPerCm * 5)) == 0;
      final lineLength = isMajorTick ? 30.0 : 20.0;
      
      canvas.drawLine(
        Offset(i, 0),              // 起点改为顶部
        Offset(i, lineLength),     // 终点
        paint,
      );

      if (isMajorTick) {
        final textSpan = TextSpan(
          text: '${(i ~/ pixelsPerCm).toInt()}',
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();
        
        // 调整文字位置到线条下方
        textPainter.paint(
          canvas,
          Offset(i - 6, lineLength + 5),  // Y 坐标放在线条下方
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}