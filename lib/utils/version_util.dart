import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'dart:convert' as convert;
import 'package:flutter_app/model/domain_source_model.dart' as model;

///检查是否需要更新
Future<Map<String, dynamic>> checkUpdate() async {
  bool isNeedUpdate = false;
  //从本地获取最新版本信息
  String versionStr = await lightKV.getString(Config.UPDATE_INFO);
  if (versionStr == null || versionStr.isEmpty) return {};
  List<dynamic> list = convert.jsonDecode(versionStr);
  prefix0.String newVersion = "";
  Map<prefix0.String, dynamic> versionInfo = prefix0.Map();
  String phoneStr;
  if (Platform.isAndroid) {
    phoneStr = "android";
  } else {
    phoneStr = "ios";
  }
  model.CheckVersionBean phoneBean;
  for (dynamic bean in list) {
    model.CheckVersionBean checkVersionBean =
        model.CheckVersionBean.fromMap(bean);
    if (checkVersionBean.platform.toLowerCase() == phoneStr) {
      phoneBean = checkVersionBean;
      break;
    }
  }
  if (phoneBean == null) {
    newVersion = "";
    isNeedUpdate = false;
  } else {
    //是否需要更新
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String version = packageInfo.version;
    String version = Config.innerVersion;
    //按位去比较版本号
    isNeedUpdate = compareVersion(version, phoneBean.verName);
    if (isNeedUpdate) {
      newVersion = phoneBean.verName;
      isNeedUpdate = true;
    }
  }
  versionInfo['newVersion'] = newVersion;
  versionInfo['isNeedUpdate'] = isNeedUpdate;
  versionInfo['versionBean'] = phoneBean;
  return versionInfo;
}

///比较版本号
bool compareVersion(String version, String newVersion) {
  bool isNeedUpdate = false;
  List localVersionArray = version.split(".");
  List newVersionArray = newVersion.split(".");
  for (int i = 0; i < newVersion.length; i++) {
    if (i > 2) {
      break;
    }

    int newVersionCode = int.parse(newVersionArray[i]);
    int compare = int.parse(localVersionArray[i]);

    if (newVersionCode > compare) {
      isNeedUpdate = true;
      break;
    } else if (newVersionCode < compare) {
      isNeedUpdate = false;
      break;
    }
  }
  return isNeedUpdate;
}
