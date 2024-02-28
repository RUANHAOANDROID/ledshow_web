import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ledshow_web/constants.dart';

//加载弹窗
Future<bool> showLoadingDialog(
    BuildContext context, Future<bool> Function() operation) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      var tipStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue);
      return Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child: Column(
            children: [
              SpinKitFadingCircle(color: Colors.blue),
              Padding(padding: EdgeInsets.all(defaultPadding)),
              Text("请等待...", style: tipStyle)
            ],
          ),
        ),
      );
    },
  );
  //执行一个操作，该操作返回bool类型
  bool result = await operation();
  //关闭弹窗
  Navigator.of(context).pop();
  //返回最终结果
  return result;
}
