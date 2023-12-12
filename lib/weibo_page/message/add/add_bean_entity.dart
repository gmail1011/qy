import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class AddBeanEntity with JsonConvert<AddBeanEntity> {
	int code;
	AddBeanData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class AddBeanData with JsonConvert<AddBeanData> {
	bool hasNext;
	@JSONField(name: "list")
	List<AddBeanDataList> xList;
}

class AddBeanDataList with JsonConvert<AddBeanDataList> {
	int uid;
	String name;
	String gender;
	String portrait;
	bool hasLocked;
	bool hasBanned;
	int vipLevel;
	bool isVip;
	int rechargeLevel;
	bool superUser;
	int activeValue;
	bool officialCert;
	int age;
	int follows;
	int fans;
	String summary;
	bool hasFollowed;
}
