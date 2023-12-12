import 'dart:math';

import 'package:dns_client/dns_client.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:http/http.dart' as http;

/// 网络dns解析
class HttpDns {
  /// 获取ip
  /// 返回 `23.224.60.99` 不包含http和https
  Future<String> getIp(String url) async {
    if (TextUtil.isEmpty(url)) return null;
    var uri = Uri.tryParse(url);
    var auth = uri.authority;
    var host = uri.host;
    var origin = uri.origin;
    print("input=========>:$url auth:$auth  host:$host origin:$origin");
    // var dns = DnsOverHttps('http://119.29.29.29/d?dn=',
    //     timeout: Duration(seconds: 5000));

    // var response = await dns.lookup(auth);
    // response.forEach((address) {
    //   print("ali parse:${address.toString()}");
    // });
    String ip;
    final resp = await http.get("http://119.29.29.29/d?dn=$auth",
        headers: {'accept': 'application/dns-json'});
    if (TextUtil.isNotEmpty(resp?.body)) {
      print("$auth --> ${resp?.body}");
      var arr1 = resp.body.split(";");
      if (ArrayUtil.isNotEmpty(arr1)) {
        ip = arr1[Random().nextInt(arr1.length)];
        if (ip.contains("|")) {
          var arr2 = ip.split("|");
          if (ArrayUtil.isNotEmpty(arr2)) {
            ip = arr2[0];
          }
        }
        if (ip.contains(",")) {
          var arr2 = ip.split(",");
          if (ArrayUtil.isNotEmpty(arr2)) {
            ip = arr2[0];
          }
        }
      }
    }
    if (TextUtil.isEmpty(ip)) {
      var dns = DnsOverHttps.google();
      var listDns = await dns.lookup(auth);
      listDns?.forEach((inet) {
        print(
            "google parse:${inet.toString()}  address:${inet.address} host:${inet.host}");
      });
      if (ArrayUtil.isNotEmpty(listDns)) {
        ip = listDns[Random().nextInt(listDns.length)].address;
      }
    }
    if (TextUtil.isEmpty(ip)) {
      var dns = DnsOverHttps.cloudflare();
      var listDns = await dns.lookup(auth);
      listDns?.forEach((inet) {
        print(
            "google parse:${inet.toString()}  address:${inet.address} host:${inet.host}");
      });
      if (ArrayUtil.isNotEmpty(listDns)) {
        ip = listDns[Random().nextInt(listDns.length)].address;
      }
    }

    return ip;
  }
}
