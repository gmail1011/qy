import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/city_model.dart';

class YuePaoSelectCityState implements Cloneable<YuePaoSelectCityState> {
  List<CityInfo> hotCityList = List();
  List<CityInfo> cityList = List();
  List<CityInfo> searchList = List();
  int suspensionHeight = 40;
  int itemHeight = 50;
  TextEditingController editingController = TextEditingController();
  @override
  YuePaoSelectCityState clone() {
    return YuePaoSelectCityState()
      ..hotCityList = hotCityList
      ..cityList = cityList
      ..searchList = searchList
      ..editingController = editingController;
  }
}

YuePaoSelectCityState initState(Map<String, dynamic> args) {
  return YuePaoSelectCityState();
}
