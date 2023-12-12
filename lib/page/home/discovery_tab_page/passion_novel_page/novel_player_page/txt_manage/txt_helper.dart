import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';

var _dio = DioCli();

class TxtHelper {
  static TxtHelper _instance;

  factory TxtHelper() {
    if (_instance == null) {
      _instance = TxtHelper._();
    }
    return _instance;
  }
  TxtHelper._();

  Future<List<String>> getSplitTxtList(String reletivePath) async {
    // var url =
    //     "http://192.168.1.164:8090/novel/text/pz/1yo/109/211/74f437eea70a7c7e70f25b7df6aa2e96.txt";
    var url = CacheServer().getLocalUrl(reletivePath);
    var resList = [];
    try {
      // var resp = await _dio.getBytes(url);
      var resp = await _dio.getStr(url);
      // var data = resp?.data?.data?.sublist(encryptMagicNumber.length) ?? [];
      // var str = String.fromCharCodes(Uint8List.fromList(data));
      var data = resp?.data?.data
              // ?.substring(encryptMagicNumber.length)
              // ?.replaceAll(String.fromCharCodes(encryptMagicNumber), "")
              ?.split('\n') ??
          [];
      // resList = str.split('\n');
      resList = data;
    } catch (e) {
      l.d("getSplitTxtList", e.toString());
    }

    return resList;
  }
}
