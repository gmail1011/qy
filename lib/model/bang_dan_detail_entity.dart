import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class BangDanDetailEntity with JsonConvert<BangDanDetailEntity> {
  int code;
  BangDanDetailData data;
  bool hash;
  String msg;
  String time;
  String tip;
}

class BangDanDetailData with JsonConvert<BangDanDetailData> {
  List<BangDanRankType> list;
}

class BangDanRankType with JsonConvert<BangDanRankType> {
  int type;
  String typeDesc;
  List<BangDanDetailDataMembers> members;
}

class BangDanDetailDataMembers with JsonConvert<BangDanDetailDataMembers> {
  String name;
  String avatar;
  String value;
  int id;
  bool superUser;
  int merchantUser;
  int vipLevel;
  String vipExpireDate;

}
