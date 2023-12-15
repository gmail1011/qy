import 'package:flutter_base/utils/log.dart';

class DateTimeUtil {
  ///日期时间本地格式化
  static String utc2iso(String formattedString) {
    if (formattedString == null || formattedString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(formattedString).toLocal();
      String y = _fourDigits(dateTime.year);
      String m = _twoDigits(dateTime.month);
      String d = _twoDigits(dateTime.day);
      String h = _twoDigits(dateTime.hour);
      String min = _twoDigits(dateTime.minute);
      String sec = _twoDigits(dateTime.second);
      return "$y-$m-$d $h:$min:$sec";
    } catch (e) {
      return '';
    }
  }

  static String utc4iso(String formattedString) {
    if (formattedString == null || formattedString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(formattedString).toLocal();
      String m = _twoDigits(dateTime.month);
      String d = _twoDigits(dateTime.day);
      String h = _twoDigits(dateTime.hour);
      String min = _twoDigits(dateTime.minute);
      return "$m-$d $h:$min";
    } catch (e) {
      return '';
    }
  }
  ///日期时间本地格式化
  static String utc2isoYMD(String formattedString) {
    if (formattedString == null || formattedString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(formattedString).toLocal();
      String y = _fourDigits(dateTime.year);
      String m = _twoDigits(dateTime.month);
      String d = _twoDigits(dateTime.day);
      return "$y-$m-$d";
    } catch (e) {
      return '';
    }
  }

  ///2020-11-26T17:44:45.000Z
  static String format2utc(DateTime dateTime) {
    String y = _fourDigits(dateTime.year);
    String m = _twoDigits(dateTime.month);
    String d = _twoDigits(dateTime.day);
    String h = _twoDigits(dateTime.hour);
    String min = _twoDigits(dateTime.minute);
    String sec = _twoDigits(dateTime.second);
    String ms = _threeDigits(dateTime.millisecond);
    return "$y-$m-${d}T$h:$min:$sec.${ms}Z";
  }

  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  ///utc 转 年月日
  static String utcTurnYear(String date, {String char, bool isChina}) {
    if (date == null || date.isEmpty) return '';
    String gap = char ?? "-";
    DateTime dateTime = DateTime.parse(date).toLocal();
    String y = _fourDigits(dateTime.year);
    String m = _twoDigits(dateTime.month);
    String d = _twoDigits(dateTime.day);
    if (isChina == true) {
      return "$y年$m月$d日";
    }
    return "$y$gap$m$gap$d ";
  }

  ///utc 转 月日
  static String utc2MonthDay(String date) {
    if (date == null || date.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      String m = _twoDigits(dateTime.month);
      String d = _twoDigits(dateTime.day);
      return "$m-$d ";
    } catch (e) {
      return '';
    }
  }

  ///计算时间差值
  static String calTime(String date, DateTime serverTime) {
    //解析时间
    var time = DateTime.parse(date).toLocal();
    //计算时间差
    var difference = time.difference(serverTime ?? DateTime.now());

    String day = difference.inDays.toString();
    String hours = (difference.inHours % 24).toString();
    String minutes = (difference.inMinutes % 60).toString();
    return day + "_" + hours + "_" + minutes;
  }

  ///日期时间本地格式化
  static String utc2iso2(String formattedString) {
    if (formattedString == null || formattedString.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(formattedString).toLocal();
      String m = _twoDigits(dateTime.month);
      String d = _twoDigits(dateTime.day);
      String h = _twoDigits(dateTime.hour);
      String min = _twoDigits(dateTime.minute);
      return "$m-$d $h:$min";
    } catch (e) {
      return '';
    }
  }

  ///utc 转 年月日
  static String utcTurnYear2(String date) {
    if (date == null || date.isEmpty) return '';
    DateTime dateTime = DateTime.parse(date).toLocal();
    String y = _fourDigits(dateTime.year);
    String m = _twoDigits(dateTime.month);
    String d = _twoDigits(dateTime.day);
    return "$y/$m/$d ";
  }

  static bool compareTime(String date) {
    if (date == null || date.isEmpty) return false;

    try {
      DateTime dateNowTime = DateTime.now().toLocal();
      String y = _fourDigits(dateNowTime.year);
      String m = _twoDigits(dateNowTime.month);
      String d = _twoDigits(dateNowTime.day);

      String nowDateStr = "$y-$m-$d";
      String newDateStr = DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toString();
      String dateStr = utcTurnYear(newDateStr).trim();
      return nowDateStr == dateStr;
    } catch (e) {
      l.e("compareTime--->", "$e");
    }
    return false;
  }

  static String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

    final minutesString =
    minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

    final secondsString =
    seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

    return formattedTime;
  }
}
