class HotCityModel {
  List<String> hotList;
  List<String> cityList;

  HotCityModel({
    this.hotList,
    this.cityList,
  });

  HotCityModel.fromJson(Map<String, dynamic> json) {
    hotList = json['hotCity'] == null ? [] : json['hotCity'].cast<String>();
    cityList = json['city'] == null ? [] : json['city'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.cityList;
    data['hotCity'] = this.hotList;
    return data;
  }
}
