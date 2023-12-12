import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class CitySelectState with EagleHelper implements Cloneable<CitySelectState> {
  List<CityInfo> cityList = List();
  List<CityInfo> hotCityList = List();
  List<CityInfo> recentCityList = List();

  String suspensionTag = "";

  int suspensionHeight = 40;
  double itemHeight = 50;

  @override
  CitySelectState clone() {
    CitySelectState citySelectState = CitySelectState();
    citySelectState.suspensionHeight = suspensionHeight;
    citySelectState.itemHeight = itemHeight;
    citySelectState.suspensionTag = suspensionTag;
    citySelectState.cityList = cityList;
    citySelectState.hotCityList = hotCityList;
    citySelectState.recentCityList = recentCityList; //历史访问
    return citySelectState;
  }
}

CitySelectState initState(Map<String, dynamic> args) {
  CitySelectState citySelectState = CitySelectState();
  citySelectState.suspensionHeight = 40;
  citySelectState.itemHeight = 50;
  citySelectState.suspensionTag = "";
  citySelectState.recentCityList = List();
  return citySelectState;
}
