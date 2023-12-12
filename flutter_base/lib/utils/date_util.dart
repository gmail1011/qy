/// 构建时分秒`00:00:00`
String buildHHMMSS(int seconds) {
  int hour = seconds ~/ 3600;
  int minute = (seconds ~/ 60) % 60;
  int second = seconds % 60;
  return _formatTime(hour) +
      ":" +
      _formatTime(minute) +
      ":" +
      _formatTime(second);
}

/// 构建分秒`00:00:00`
String buildMMSS(int seconds) {
  int minute = seconds ~/ 60;
  int second = seconds % 60;
  return _formatTime(minute) + ":" + _formatTime(second);
}

//数字格式化，将 0~9 的时间转换为 00~09
String _formatTime(int timeNum) {
  return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
}
