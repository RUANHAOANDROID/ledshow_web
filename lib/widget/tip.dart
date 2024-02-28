import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tip extends StatelessWidget {
  final String tip;
  final bool ok = false;

  const Tip({Key? key, required this.tip, ok}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (ok) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }
    double myHeight = 40;
    return Container(
      height: myHeight,
      alignment: Alignment.center,
      child: Text(
        '$tip',
        style: TextStyle(color: color),
      ),
    );
  }
}
