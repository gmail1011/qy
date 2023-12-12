import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class AVCommentaryEntity with JsonConvert<AVCommentaryEntity> {
	int code;
	AVCommentaryData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class AVCommentaryData with JsonConvert<AVCommentaryData> {
	@JSONField(name: "list")
	List<AVCommentaryDataList> xList;
	int total;
}

class AVCommentaryDataList with JsonConvert<AVCommentaryDataList> {
	String id;
	String title;
	String desc;
	String videoInfo;
	int period;
	String cover;
	String sourceID;
	String sourceURL;
	int price;
	String createdAt;
	String graphic;
	List<String> tags;
}
