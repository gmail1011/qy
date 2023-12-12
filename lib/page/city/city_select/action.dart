import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/city_model.dart';

enum CitySelectAction {
  getCityListSuccess,
  onSlideCityList,
  onClickCity,
  getHistory,
  onClickHistory,
  onAutoLocation,
  updateUI,
}

class CitySelectActionCreator {
  static Action onAutoLocation() {
    return const Action(CitySelectAction.onAutoLocation);
  }

  static Action getCityListSuccess(List<CityInfo> hotCityList) {
    return Action(CitySelectAction.getCityListSuccess, payload: hotCityList);
  }

  static Action onSlideCityList(String tag) {
    return Action(CitySelectAction.onSlideCityList, payload: tag);
  }

  static Action onClickCity(String cityName, String province,
      {bool localCityIsAuto = false}) {
    Map<String, dynamic> map = Map();
    map['city'] = cityName;
    map['province'] = province;
    return Action(CitySelectAction.onClickCity, payload: map);
  }

  static Action onClickHistory(String name) {
    return Action(CitySelectAction.onClickHistory, payload: name);
  }

  static Action getHistory(List<CityInfo> recentCityList) {
    return Action(CitySelectAction.getHistory, payload: recentCityList);
  }

  static Action updateUI() {
    return const Action(CitySelectAction.updateUI);
  }
}
