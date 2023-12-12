import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_model.dart';

enum YuePaoSelectCityAction {
  setCityData,
  setHotCityData,
  setSearchCityData,
  itemClick,
  search,
}

class YuePaoSelectCityActionCreator {
  static Action search() {
    return Action(YuePaoSelectCityAction.search);
  }

  static Action setCityData(List<CityInfo> list) {
    return Action(YuePaoSelectCityAction.setCityData, payload: list);
  }

  static Action setHotCityData(List<CityInfo> list) {
    return Action(YuePaoSelectCityAction.setHotCityData, payload: list);
  }

  static Action setSearchCityData(List<CityInfo> list) {
    return Action(YuePaoSelectCityAction.setSearchCityData, payload: list);
  }

  static Action onClickItem(String cityName) {
    return Action(YuePaoSelectCityAction.itemClick, payload: cityName);
  }
}
