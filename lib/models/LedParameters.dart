class LedParameters {
  String title;
  String ip;
  int port;
  int x;
  int y;
  int width;
  int height;
  int fontSize;
  String status;

  LedParameters({
    this.title = "LED",
    this.ip = "192.168.8.199",
    this.port = 5005,
    this.x = 0,
    this.y = 0,
    this.width = 32,
    this.height = 16,
    this.fontSize = 10,
    this.status = "status",
  });
}