class Resp<T> {
  final int code;
  final String msg;
  final T? data;

  Resp({required this.code, required this.msg, this.data});

}

final SUCCESS = 1;
final FAIL = 0;
