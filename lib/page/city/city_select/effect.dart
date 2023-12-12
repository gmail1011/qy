import 'dart:async';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/cities.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_app/model/new_hot_city_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'action.dart';
import 'state.dart';

Effect<CitySelectState> buildEffect() {
  return combineEffects(<Object, Effect<CitySelectState>>{
    Lifecycle.initState: _onInitData,
    CitySelectAction.onClickCity: _onClickCity,
    CitySelectAction.onClickHistory: _onClickHistory,
    CitySelectAction.onAutoLocation: _onAutoLocation,
  });
}

Future _onInitData(Action action, Context<CitySelectState> ctx) async {
  //获取城市列表
  List<CityInfo> list1 = List();
  Directory dbPath = await getApplicationDocumentsDirectory();

  String path = dbPath.path + "/asset_database.db";
  ByteData data = await rootBundle.load(AssetsCities.CHINA_CITIES_V2);
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  //将读出来的数据库文件写入文件中
  File file = File(path);
  var isExists = await file.exists();
  if (!isExists) {
    await file.create();
    await file.writeAsBytes(bytes, flush: true);
  }

  Future.delayed(Duration(milliseconds: 300), () {
    //从数据库中读取
    openDatabase(path).then((value) {
      Database db = value;
      String query = "select * from cities";
      db.rawQuery(query).then((value) {
        for (int i = 0; i < value.length; i++) {
          list1.add(CityInfo(
              name: value[i]['c_name'], province: value[i]['c_province']));
        }
        _handleList(list1, ctx);
        ctx.dispatch(CitySelectActionCreator.getCityListSuccess(list1));
        db.close();
      });
    });
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  //获取历史记录
  getHistoryList(ctx);

  //获取热门城市
  _onHotCityList(ctx);
}

///自动定位
_onAutoLocation(Action action, Context<CitySelectState> ctx) async {
  LocationBean autoLocationModel;
  try {
    autoLocationModel = await netManager.client.autoLocation();
  } catch (e) {
    l.e("autoLocation", e.toString());
  }
  if (autoLocationModel != null) {
    ctx.dispatch(CitySelectActionCreator.onClickCity(
        autoLocationModel.city, autoLocationModel.province));
  }
}

/// 获取历史记录
getHistoryList(Context<CitySelectState> ctx) async {
  List<String> historyList = await lightKV.getStringList("history");
  List<CityInfo> recentList = List();
  if (historyList != null) {
    for (int i = 0; i < historyList.length; i++) {
      String name = historyList[i].split("_")[0];
      String province = historyList[i].split("_")[1];
      recentList.add(CityInfo(name: name, tagIndex: "★", province: province));
    }
    ctx.dispatch(CitySelectActionCreator.getHistory(recentList));
  }
}

_handleList(List<CityInfo> list, Context<CitySelectState> ctx) {
  if (list == null || list.isEmpty) return;
  for (int i = 0, length = list.length; i < length; i++) {
    String pinyin = PinyinHelper.getPinyinE(list[i].name);
    String tag = pinyin.substring(0, 1).toUpperCase();
    list[i].namePinyin = pinyin;
    if (RegExp("[A-Z]").hasMatch(tag)) {
      list[i].tagIndex = tag;
    } else {
      list[i].tagIndex = "#";
    }
  }
  //根据A-Z排序
  SuspensionUtil.sortListBySuspensionTag(list);
  SuspensionUtil.setShowSuspensionStatus(list);
}

///点击城市列表Item
_onClickCity(Action action, Context<CitySelectState> ctx) async {
  Map<String, dynamic> maps = action.payload;
  String city = maps['city'];
  String province = maps['province'];

  println(city + "---" + province);
  //将点击城市记录到sp里
  List<String> historyList = await lightKV.getStringList("history");
  if (historyList == null) {
    //如果为空
    historyList = List();
    historyList.add(city + "_" + province);
  } else {
    //如果非空
    //如果已经有6个了

    //首先判断集合里面是否有重复的
    bool isSame = false;
    for (int i = 0; i < historyList.length; i++) {
      if (historyList[i].split("_")[0] == city) {
        isSame = true;
      }
    }
    if (!isSame) {
      if (historyList.length > 5) {
        //替换掉最后一个
        historyList.removeLast();
        historyList.add(city + "_" + province);
      } else {
        historyList.add(city + "_" + province);
      }
    }
  }
  lightKV.setStringList("history", historyList);

  Config.selectCity = city + "_" + province;

  //回到上个页面,并且把城市返回,,,也要把省份传回去
  safePopPage(city + "_" + province);
}

///点击历史访问
_onClickHistory(Action action, Context<CitySelectState> ctx) {
  safePopPage(action.payload);
}

///热门城市
_onHotCityList(Context<CitySelectState> ctx) async {
  List<NewHotCity> cityInfoList;
  try {
    cityInfoList = await netManager.client.getHotCity();
    if (cityInfoList != null && cityInfoList.length > 0) {
      cityInfoList.sort((left, right) => left.hot.compareTo(right.hot));
      l.e("getHotCity-list", cityInfoList.toString());

      List<CityInfo> hotCityList = List();
      for (NewHotCity hotCity in cityInfoList) {
        hotCityList.add(CityInfo(
            name: hotCity.city,
            tagIndex: "★",
            province: hotCity.province ?? ""));
      }
      if ((hotCityList ?? []).isNotEmpty) {
        ctx.state.hotCityList = hotCityList;
        ctx.state.suspensionTag = ctx.state.hotCityList[0].getSuspensionTag();
      }
      ctx.dispatch(CitySelectActionCreator.updateUI());
    }
  } catch (e) {
    l.e("getHotCity", e.toString());
  }
}
