import 'package:azlistview/azlistview.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:lpinyin/lpinyin.dart';
import 'action.dart';
import 'state.dart';

Effect<YuePaoSelectCityState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoSelectCityState>>{
    YuePaoSelectCityAction.itemClick: _onClickCity,
    YuePaoSelectCityAction.search: _onSearchCity,
    Lifecycle.initState: _initData
  });
}

// 点击城市
void _onClickCity(Action action, Context<YuePaoSelectCityState> ctx) async {
  var city = action.payload;

  safePopPage(city ?? '');
}

// 搜索城市
void _onSearchCity(Action action, Context<YuePaoSelectCityState> ctx) async {
  var text = ctx.state.editingController.text.toLowerCase();
  var list = ctx.state.cityList;
  if (TextUtil.isNotEmpty(text)) {
    var search = <CityInfo>[];
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      var py = item.namePinyin.replaceAll(" ", "");
      if (item.name.contains(text) ||
          item.jianpin.contains(text) ||
          py.contains(text)) {
        search.add(item);
      }
    }
    SuspensionUtil.setShowSuspensionStatus(search); //搜索后必须要重新刷新下状态
    ctx.dispatch(YuePaoSelectCityActionCreator.setSearchCityData(search));
  } else {
    ctx.dispatch(YuePaoSelectCityActionCreator.setSearchCityData(list));
  }
}

void _initData(Action action, Context<YuePaoSelectCityState> ctx) async {
  // 获取热门城市
  _getCityList(ctx);
}

/// 获取热门城市
void _getCityList(Context<YuePaoSelectCityState> ctx) async {
  try {
    var hotCityModel = await netManager.client.getHotCityList();
    List<String> list = hotCityModel.hotList ?? [];
    List<String> city = hotCityModel.cityList ?? [];
    List<CityInfo> hotList = [];
    List<CityInfo> cityList = [];
    for (var i = 0; i < list.length; i++) {
      hotList.add(CityInfo(name: list[i], tagIndex: "★", province: ""));
    }
    ctx.dispatch(YuePaoSelectCityActionCreator.setHotCityData(hotList));
    for (var i = 0; i < city.length; i++) {
      if (city[i] != null) {
        cityList.add(CityInfo(name: city[i]));
      }
    }
    _handleList(cityList, ctx);
    ctx.dispatch(YuePaoSelectCityActionCreator.setCityData(cityList));
  } catch (e) {
    l.e('getHotCityList=', e.toString());
  }
}

_handleList(List<CityInfo> list, Context<YuePaoSelectCityState> ctx) {
  if (list == null || list.isEmpty) return;
  for (int i = 0, length = list.length; i < length; i++) {
    String pinyin = PinyinHelper.getPinyinE(list[i].name);
    list[i].jianpin = PinyinHelper.getShortPinyin(list[i].name);

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
