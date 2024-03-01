bool isValidIPAddress(String ipAddress) {
  // IPv4地址的正则表达式
  final ipv4RegExp = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  // IPv6地址的正则表达式
  final ipv6RegExp = RegExp(r'^([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:)$');

  return ipv4RegExp.hasMatch(ipAddress) || ipv6RegExp.hasMatch(ipAddress);
}
