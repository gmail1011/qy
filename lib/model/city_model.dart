import 'package:azlistview/azlistview.dart';

class CityInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;
  String province;
  String jianpin;

  CityInfo({
    this.name,
    this.tagIndex,
    this.namePinyin,
    this.province,
    this.jianpin,
  });

  CityInfo.fromJson(Map<String, dynamic> json) {
    this.name = json['name'] == null ? "" : json['name'];
    this.province = json['province'] == null ? "" : json['province'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" + " \"name\":\"" + name + "\"" + '}';
}
