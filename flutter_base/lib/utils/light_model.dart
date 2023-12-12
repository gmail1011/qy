import 'dart:convert';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';

/// 轻量级别存储模型(kv键值对)内部包含文件和内存缓存
final lightKV = _LightModel();

class _LightModel {
  MmkvFlutter mmkv;
  init() async {
    if (null == mmkv) mmkv = await MmkvFlutter.getInstance();
  }

  Future<bool> remove(String key) async {
    await init();
    return mmkv.removeByKey(key);
  }

  Future<String> getString(String key) async {
    await init();
    if (TextUtil.isEmpty(key)) return null;
    var newKey = '$key';
    return mmkv.getString(newKey);
  }

  Future<bool> setString(String key, String value,
      [bool genNewKey = true]) async {
    await init();
    if (TextUtil.isEmpty(key)) return false;
    var newKey = '$key';
    return mmkv.setString(newKey, value);
  }

  Future<int> getInt(String key) async {
    await init();
    if (TextUtil.isEmpty(key)) return null;
    var newKey = '$key';
    return mmkv.getInt(newKey);
  }

  Future<bool> setInt(String key, int value) async {
    await init();
    if (TextUtil.isEmpty(key)) return false;
    var newKey = '$key';
    return mmkv.setInt(newKey, value);
  }

  Future<bool> getBool(String key) async {
    await init();
    if (TextUtil.isEmpty(key)) return null;
    var newKey = '$key';
    return mmkv.getBool(newKey);
  }

  Future<bool> setBool(String key, bool value) async {
    await init();
    if (TextUtil.isEmpty(key)) return false;
    var newKey = '$key';
    return mmkv.setBool(newKey, value);
  }

  Future<List<String>> getStringList(String key,
      [bool genNewKey = true]) async {
    await init();
    if (TextUtil.isEmpty(key)) return null;
    var newKey = '$key';
    var jsonS = await mmkv.getString(newKey);
    if (TextUtil.isEmpty(jsonS))
      return <String>[];
    else {
      return json.decode(jsonS)?.cast<String>();
    }
  }

  ///
  Future<bool> setStringList(String key, List<String> list,
      [bool genNewKey = true]) async {
    await init();
    if (TextUtil.isEmpty(key)) return false;
    var newKey = '$key';
    if (ArrayUtil.isEmpty(list))
      return mmkv.setString(newKey, null);
    else {
      var jsonS = json.encode(list);
      return mmkv.setString(newKey, jsonS);
    }
  }
}
