import 'dart:async';

import 'package:flutter_base/net/http_dns.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('teste1', () async {
    Completer<int> completer = Completer();
    var future = completer.future;
    () async {
      await Future.delayed(Duration(seconds: 2));
      completer.completeError("completer throw error");
    }();
    print("begin end ");
    var value = await future;
    print("what end is :$value");
  });
  test("test2", () {
    T1 t1;
    print("test1");
    t1?.t2 = false;
    print("test2");
  });

  test("test3", () {
    var d = double.parse("8848.4");
    var i = d.toInt();
    print(i);
  });

  test("testHttpDns", () async {
    String ip = await HttpDns().getIp("https://dspjs.chenyys.com");
    print("ip:$ip");
    // await HttpDnsUtil().getIp("dspjs.chenyys.com"); // error
  });
}

class T1 {
  bool t2;
}
