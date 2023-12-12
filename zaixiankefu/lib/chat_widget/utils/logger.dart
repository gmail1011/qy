import 'package:r_logger/r_logger.dart';

class PrintUtil {
  factory PrintUtil() => _shareInstance();

  static PrintUtil instance;

  PrintUtil._() {
    init();
  }

  static PrintUtil _shareInstance() {
    if (instance == null) {
      instance = PrintUtil._();
    }
    return instance;
  }

  void init() {
    RLogger.initLogger(
        tag: "ws", isWriteFile: false, filePath: '', fileName: 'xx');
  }

  void log(String msg) {
    RLogger.instance.d(msg);
  }

  void logJson(String msg) {
    RLogger.instance.j(msg);
  }
}
