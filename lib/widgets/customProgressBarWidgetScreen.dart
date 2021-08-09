import 'dart:math';

import 'package:flutter/material.dart';

class CustomProgressBarWidget extends StatelessWidget {
  const CustomProgressBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomProgBarWidget(),
    );
  }
}

class CustomProgBarWidget extends StatelessWidget {
  const CustomProgBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 70,
        height: 70,
        child: RadialPercentWidget(
          percent: 17,
          fillColor: Colors.grey,
          freeColor: Colors.black,
          lineColor: Colors.lime,
          lineWidth: 3,
          child: Text(
            '17%',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class RadialPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color fillColor;
  final Color freeColor;
  final Color lineColor;
  final double lineWidth;
  const RadialPercentWidget({
    Key? key,
    required this.child,
    required this.percent,
    required this.fillColor,
    required this.freeColor,
    required this.lineWidth,
    required this.lineColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            fillColor: fillColor,
            lineColor: lineColor,
            freeColor: freeColor,
            lineWidth: lineWidth,
          ),
        ),
        Center(child: child),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  double percent;
  final Color fillColor;
  final Color freeColor;
  final Color lineColor;
  final double lineWidth;

  MyPainter({
    required this.percent,
    required this.fillColor,
    required this.freeColor,
    required this.lineColor,
    required this.lineWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    percent /= 100;
    final arcRect = calculateArcRect(size);

    drawBackgroundCircle(canvas, size);

    drawFreeCircle(canvas, arcRect);

    drawfFilledArc(canvas, arcRect);
  }

  void drawfFilledArc(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = lineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    paint.strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      3 * pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  void drawFreeCircle(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = freeColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;

    canvas.drawArc(
      arcRect,
      3 * pi / 2,
      2 * pi,
      false,
      paint,
    );
  }

  void drawBackgroundCircle(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = fillColor;
    paint.style = PaintingStyle.fill;
    canvas.drawOval(
      Offset.zero & size,
      paint,
    );
  }

  Rect calculateArcRect(Size size) {
    final double linePadding = 2;
    final offset = (lineWidth / 2 + linePadding);
    final arcRect = Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
    // final arcRect = Offset((stroke / 2 + linePadding), (stroke / 2 + linePadding)) &
    //       Size(size.width - (stroke + linePadding * 2),
    //           size.height - (stroke + linePadding * 2));

    //            Size(size.width - (stroke + linePadding * 2),
    //           size.height - (stroke + linePadding * 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
