import 'package:flutter/material.dart';
import 'dart:math';

import 'package:ledshow_web/constants.dart';

class CustomStatus extends StatefulWidget {
  final Color color;
  final String status;

  const CustomStatus({Key? key, required this.color, required this.status})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomStatus();
}

class _CustomStatus extends State<CustomStatus> {
  @override
  Widget build(BuildContext context) {
    double width = 25;
    double height = 25;
    var drawCircle = CustomPaint(
      //size: Size(width, height), //指定画布大小
      size: Size(width, height),
      painter: MyPainter(widget.color),
    );
    var _netStatus = Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: defaultPadding/4),
          child: drawCircle,
        ),
        Text(widget.status)
      ],
    );
    return Center(
      child: _netStatus,
    );
  }
}

class MyPainter extends CustomPainter {
  final Color color;

  MyPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    //画外圈
    drawCircle(canvas, rect);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void drawCircle(Canvas canvas, Rect rect) {
    double width = rect.width;
    double height = rect.width;
    double radius = min(width, height) / 2;
    //外圈
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    //内圈
    var offset = rect.center;
    //Offset(rect.center.dx, rect.center.dy);
    canvas.drawCircle(
      offset,
      radius / 1.8,
      paint,
    );
    //外圈
    paint.color = Color.fromRGBO(color.red, color.green, color.blue, 0.5);
    canvas.drawCircle(
      offset,
      radius,
      paint,
    );
  }
}
