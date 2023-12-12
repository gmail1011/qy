library log;

import 'dart:io';
import 'package:date_format/date_format.dart' as fmt;
import 'package:flutter/foundation.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/misc_util.dart';
import 'package:logger/logger.dart';

// global log class
final l = _Log._();

/// 日志工具类，
class _Log {
  // // 获取文档目录的路径
  IOSink fileSink;
  IOSink crashSink;

  bool enablePrintLog = true;

  /// 全局控制，是否允许打印log

  /// 允许写日志文件
  bool enableWriteFile = true;

  Future initLogFile() async {
    // Directory appDocDir = await getExternalStorageDirectory();

    // if (Platform.isIOS || Platform.isMacOS) {
    //   dir = await getTemporaryDirectory();
    // } else {
    //   dir = await getExternalStorageDirectory();
    // }

    // enablePrintLog = Config.DEBUG;
    var dir = await MiscUtil.getCommonDir();

    ///判斷是 Release or debug
    enablePrintLog = !FlutterBase.isRelease;
    // enablePrintLog = true;
    var path = dir.path;
    var dataStr =
        fmt.formatDate(DateTime.now(), [fmt.yyyy, "_", fmt.mm, "_", fmt.dd]);
    final logFile = File('$path/log_$dataStr.txt');
    print(
        'begin logger print:$enablePrintLog write:$enableWriteFile savePath:${logFile.path}');
    fileSink = logFile.openWrite(mode: FileMode.append);
    final crashFile = File('$path/log_$dataStr.txt');
    crashSink = crashFile.openWrite(mode: FileMode.append);
  }

  var printer = MyPrinter();

  _Log._() {
    this._logger = Logger(
      filter: ProductionFilter(),
      printer: printer,
    );
    // Logger.level = Level.warning;
    initLogFile();
    Logger.level = Level.verbose;
  }

  Logger _logger;

  void v(String tag, dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = false}) {
    if (enablePrintLog) _logger.v('$tag#: $message', error, stackTrace);
    if (enableWriteFile && saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage('$tag#: $message');
      fileSink.write('$newMsg\n');
    }
  }

  void d(String tag, dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = false}) {
    if (enablePrintLog) _logger.d('$tag#: $message', error, stackTrace);
    if (enableWriteFile && saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage('$tag#: $message');
      fileSink.write('$newMsg\n');
    }
  }

  void i(String tag, dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = false}) {
    if (enablePrintLog) _logger.i('$tag#: $message', error, stackTrace);
    if (enableWriteFile && saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage('$tag#: $message');
      fileSink.write('$newMsg\n');
    }
  }

  void w(String tag, dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = true}) {
    if (enablePrintLog) _logger.w('$tag#: $message', error, stackTrace);
    if (enableWriteFile && saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage('$tag#: $message');
      fileSink.write('$newMsg\n');
    }
  }

  void e(String tag, dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = true}) {
    // if (enablePrintLog) _logger.w('$tag#: $message', error, stackTrace);
    if (true) _logger.e('$tag#: $message', error, stackTrace);
    // if (enableWriteFile && saveFile && null != fileSink) {
    if (saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage('$tag#: $message');
      fileSink.write('$newMsg\n');
    }
  }

  void writeCrash(dynamic message, {dynamic error, StackTrace stackTrace}) {
    var newMsg = printer.stringifyMessage(message);
    crashSink?.write('$newMsg\n error:$error\n stack:$stackTrace\n');
  }

  void wtf(dynamic message,
      {dynamic error, StackTrace stackTrace, bool saveFile = true}) {
    _logger.wtf(message, error, stackTrace);
    if (saveFile && null != fileSink) {
      var newMsg = printer.stringifyMessage(message);
      fileSink.write('$newMsg\n');
    }
  }
}

class MyPrinter extends SimplePrinter {
  // @override
  // void log(LogEvent event) {
  //   var messageStr = stringifyMessage(event.message);
  //   var errorStr = event.error != null ? "  ERROR: ${event.error}" : "";
  //   println("${levelPrefixes[event.level]}  $messageStr$errorStr");
  // }
  MyPrinter() : super(printTime: true);

  String stringifyMessage(dynamic msg) {
    // if (msg is Map || msg is Iterable) {
    //   return JsonEncoder.withIndent(null).convert(msg);
    // } else {
    // return (_getTime() + msg.toString());
    return msg.toString();
    // }
  }

  String _getTime() {
    var now = DateTime.now();
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);

    return "[$h:$min:$sec.$ms] ";
  }

  String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

debugLog(Object message) {
  if (kDebugMode) {
    if (message is String){
      String logStr = message;
      int maxLength = 526;
      if (logStr.length < maxLength){
        print(message);
      }else {
        for (int i = 0; i < logStr.length; i += maxLength) {
          if (i + maxLength < logStr.length){
            print(logStr.substring(i, i+maxLength));
          }else {
            print(logStr.substring(i, logStr.length));
          }
        }
      }

    }else {
      print(message);
    }
  }
}