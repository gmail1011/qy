class LocationBean {
  String id;
  String longitude;
  String latitude;
  String country;
  String countryCode;
  String province;
  String provinceCode;
  String city;
  String cityCode;
  String address;
  String cover;
  int visit;

  static LocationBean fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    LocationBean locationBean = LocationBean();
    locationBean.id = map['id'];
    locationBean.longitude = map['longitude'];
    locationBean.latitude = map['latitude'];
    locationBean.country = map['country'];
    locationBean.countryCode = map['countryCode'];
    locationBean.province = map['province'];
    locationBean.provinceCode = map['provinceCode'];
    locationBean.city = map['city'];
    locationBean.cityCode = map['cityCode'];
    locationBean.address = map['address'];
    locationBean.cover = map['cover'];
    locationBean.visit = map['visit'];
    return locationBean;
  }

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
        "country": country,
        "countryCode": countryCode,
        "province": province,
        "provinceCode": provinceCode,
        "city": city,
        "cityCode": cityCode,
        "address": address,
        "cover": cover,
        "visit": visit,
      };
}
