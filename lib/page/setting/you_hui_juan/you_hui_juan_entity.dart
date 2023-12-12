import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class YouHuiJuanEntity with JsonConvert<YouHuiJuanEntity> {
	int code;
	List<YouHuiJuanData> data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class YouHuiJuanData with JsonConvert<YouHuiJuanData> {
	String id;
	int uid;
	String goodsName;
	int goodsType;
	int goodsValue;
	String goodsOrigin;
	String goodsDesc;
	int status;
	String expiredTime;
	String useTime;
	String createTimt;
}
