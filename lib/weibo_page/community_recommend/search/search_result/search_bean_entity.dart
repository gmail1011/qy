import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SearchBeanEntity with JsonConvert<SearchBeanEntity> {
	int code;
	SearchBeanData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SearchBeanData with JsonConvert<SearchBeanData> {
	bool hasNext;
	@JSONField(name: "list")
	List<SearchBeanDataList> xList;
}

class SearchBeanDataList with JsonConvert<SearchBeanDataList> {
	int uid;
	String name;
	int age;
	String gender;
	String portrait;
	String region;
	String summary;
	int vipLevel;
	int rechargeLevel;
	bool superUser;
	int activeValue;
	bool officialCert;
	bool isVip;
	bool hasFollowed;
	int fansCount;
}
