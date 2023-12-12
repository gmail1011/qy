import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/// 依赖框架  flutter_native_timezone: ^1.0.4
/// 时区获取工具类
class TimeZoneTool {
  /// 获取当前所在时区
  static Future<String> getTimeZone() async {
    // 获取当前时区
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    print(currentTimeZone);
    return currentTimeZone;
  }

  /// 是否是属于美国的时区
  static Future<bool> isAmericaZone() async {
    // 获取当前时区
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    // 北美洲时区 都会以America 开头 全部屏蔽
    if (currentTimeZone.toLowerCase().contains('america')) {
      return true;
    } else {
      return false;
    }
  }
}
