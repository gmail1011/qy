import 'dart:convert';

import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/user/local_user_info.dart';
import 'dart:convert' as convert;
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';

/// 不含状态的本地存储，主要是lightmodel的序列换存储
/// 登录记录存储
class LocalUserStore {
  static LocalUserStore _instance;

  factory LocalUserStore() {
    if (_instance == null) {
      _instance = LocalUserStore._();
    }
    return _instance;
  }

  LocalUserStore._();

  Future<List<LocalUserInfo>> getUserList() async {
    String localUserStr = await lightKV.getString("_key_local_user${Config.DEBUG}");
    try {
      if (localUserStr != null && localUserStr.isNotEmpty) {
        List<LocalUserInfo> list =
            LocalUserInfo.toList(jsonDecode(localUserStr));
        return list;
      }
    } catch (_) {}
    return <LocalUserInfo>[];
  }

  Future addUser(LocalUserInfo info) async {
    if (null == info) return;
    List<LocalUserInfo> list = (await getUserList()) ?? <LocalUserInfo>[];
    LocalUserInfo targetUser;
    try {
      targetUser = list.firstWhere((item) => item.uid == info.uid);
    } catch (e) {
      l.e("", "addUser()...${info.nickName}..error$e");
    }
    if (null != targetUser) {
      if (TextUtil.isNotEmpty(info.portrait))
        targetUser.portrait = info.portrait;
      if (TextUtil.isNotEmpty(info.mobile)) targetUser.mobile = info.mobile;
      if (TextUtil.isNotEmpty(info.nickName))
        targetUser.nickName = info.nickName;
      if (TextUtil.isNotEmpty(info.qr)) targetUser.qr = info.qr;
    } else {
      list.add(info);
    }
    await lightKV.setString("_key_local_user${Config.DEBUG}", convert.jsonEncode(list));
  }

  ///清除登录记录，保留当前登录用户
  clean() {
    lightKV.setString("_key_local_user${Config.DEBUG}", "");
  }
}
