class Resp<T> {
  final int code;
  final String msg;
  final T? data;

  Resp({required this.code, required this.msg, this.data});

}

final SUCCESS = 0;
final FAIL = 1;
